/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

exports.processRaceResults = functions.pubsub.schedule("every day 00:00")
    .timeZone("UTC")
    .onRun(async (context) => {
        const db = admin.firestore();

        try {
            // Step 1: Retrieve the last processed race
            const lastProcessedRaceDoc = await db.collection("config").doc("lastProcessedRace").get();
            const lastProcessedRace = lastProcessedRaceDoc.exists ? lastProcessedRaceDoc.data() : null;

            if (!lastProcessedRace) {
                console.log("No last processed race found.");
                return null;
            }

            const { year, round } = lastProcessedRace;


            // Step 2: Call the API to get the race results
            const apiResponse = await axios.get(`https://sportsdataanalytics.onrender.com/home/last_race_results/`).catch(error => {
                console.error("Error fetching race results:", error.message);
                return null;
            });
            
            if (!apiResponse || !apiResponse.data) {
                console.log(`No race results found last race`);
                return null;
            }

            const raceResults = apiResponse.data;

            if (raceResults.year === String(year) && raceResults.race_id === String(round)) {
                console.log(`Race results for year ${year} and round ${round} already processed`);
                return null;
            }

            console.log(`Processing results for last race`);

            const raceYear = parseInt(raceResults.year, 10);
            if (isNaN(raceYear)) {
                console.error("Invalid race year:", raceResults.year);
                return null;
            }

            const raceRound = parseInt(raceResults.race_id, 10);
            if (isNaN(raceRound)) {
                console.error("Invalid race round:", raceResults.race_id);
                return null;
            }

            // Step 3: Retrieve user predictions
            const predictionsSnapshot = await db.collection("predictions")
                .where("year", "==", raceYear)
                .where("round", "==", raceRound)
                .get();

            if (predictionsSnapshot.empty) {
                console.log(`No predictions found for year ${raceYear} and round ${raceRound}`);
                return null;
            }

            const batch = db.batch();

            // Step 4: Compare predictions with results and update points
            predictionsSnapshot.forEach((doc) => {
                const prediction = doc.data();
                const predictionId = doc.id;
                const userId = prediction.userId;

                // Extract actual race results from the JSON
                const actualWinnerId = raceResults.first_position.driver_id;
                const actualPodiumIds = [
                    raceResults.first_position.driver_id,
                    raceResults.second_position.driver_id,
                    raceResults.third_position.driver_id,
                ];
                const actualFastestLapId = raceResults.fastest_lap.driver_id;

                // Initialize points
                let points = 0;

                // Award 30 points for correct winner
                if (prediction.winnerId === actualWinnerId) {
                    points += 30; // Correct winner
                }

                // Award 20 points for matching any driver in the podium
                if (prediction.podiumIds) {
                    const matchedPodiumDrivers = prediction.podiumIds.filter((driver) =>
                        actualPodiumIds.includes(driver)
                    );
                    points += matchedPodiumDrivers.length * 10; // 10 points per correct podium driver
                }

                // Award 30 points for correctly predicting the fastest lap driver
                if (prediction.fastestLapId === actualFastestLapId) {
                    points += 30; // Correct fastest lap
                }

                console.log(`User ${userId} gained ${points} points for race year ${raceYear}, round ${raceRound}`);

                // Update user points in Firestore
                const userRef = db.collection("users").doc(userId);
                batch.update(userRef, {
                    seasonPoints: admin.firestore.FieldValue.increment(points), // Update season points
                    totalPoints: admin.firestore.FieldValue.increment(points), // Update total points
                });

                // Update prediction document with the points gained
                const predictionRef = db.collection("predictions").doc(predictionId);
                batch.update(predictionRef, { points: points }); // Add the points to the prediction document
            });

            // Step 5: Call the API to get upcoming race details
            const apiResponse2 = await axios.get(`https://sportsdataanalytics.onrender.com/home/upcoming_race/`).catch(error => {
                console.error("Error fetching upcoming race details:", error.message);
                return null;
            });

            if (!apiResponse2 || !apiResponse2.data) {
                console.log(`No upcoming race found`);
                return null;
            }

            const upcomingRace = apiResponse2.data;

            // Extract year and round from the API response and convert them to integers
            const nextRaceYear = parseInt(upcomingRace.year, 10); // Convert year to integer
            if (isNaN(nextRaceYear)) {
                console.error("Invalid next race year:", upcomingRace.year);
                return null;
            }

            const nextRaceRound = parseInt(upcomingRace.race_id, 10); // Convert race_id to integer
            if (isNaN(nextRaceRound)) {
                console.error("Invalid next race round:", upcomingRace.race_id);
                return null;
            }

            // Step 6: Mark the race as processed
            batch.update(db.collection("config").doc("lastProcessedRace"), {
                year: nextRaceYear,
                round: nextRaceRound,
            });

            // Commit the batch
            await batch.commit();
            console.log(`Successfully processed race for year ${year}, round ${round}`);
        } catch (error) {
            console.error("Error processing race results:", error);
        }

        return null;
    });