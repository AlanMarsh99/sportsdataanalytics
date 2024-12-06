/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

exports.processRaceResults = functions
    .region('europe-west3')
    .pubsub.schedule("every day 00:00")
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

            /*const raceResults = {
                race_id: "23",
                first_position: {
                    driver_name: "Max Verstappen",
                    team_name: "Red Bull",
                    driver_id: "max_verstappen",
                },
                second_position: {
                    driver_name: "Lewis Hamilton",
                    team_name: "Mercedes",
                    driver_id: "hamilton",
                },
                third_position: {
                    driver_name: "Charles Leclerc",
                    team_name: "Ferrari",
                    driver_id: "leclerc",
                },
                fastest_lap: {
                    driver_name: "Max Verstappen",
                    team_name: "Red Bull",
                    driver_id: "max_verstappen",
                },
                year: "2024",
            };*/

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

            // Step 4: Compare predictions with results and update points
            const batch = db.batch();
            const updatePromises = []; // Store promises for async operations

            predictionsSnapshot.forEach((doc) => {
                const prediction = doc.data();
                const predictionId = doc.id;
                const userId = prediction.userId;

                if (prediction.points === null || prediction.points === undefined) {
                    // Extract actual race results from the JSON
                    const actualWinnerId = raceResults.first_position.driver_id;
                    const actualPodiumIds = [
                        raceResults.first_position.driver_id,
                        raceResults.second_position.driver_id,
                        raceResults.third_position.driver_id,
                    ];
                    const actualFastestLapId = raceResults.fastest_lap.driver_id;

                    // Get names for actual results
                    const actualWinnerName = raceResults.first_position.driver_name;
                    const actualPodiumNames = [
                        raceResults.first_position.driver_name,
                        raceResults.second_position.driver_name,
                        raceResults.third_position.driver_name,
                    ];
                    const actualFastestLapName = raceResults.fastest_lap.driver_name;

                    // Initialize points
                    let points = 0;

                    // Award 30 points for correct winner
                    if (prediction.winnerId === actualWinnerId) {
                        points += 30; // Correct winner
                    }

                    // Award 10 points for matching any driver in the podium
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

                    // Get user data to calculate new level
                    updatePromises.push(
                        (async () => {
                            const userRef = db.collection("users").doc(userId);
                            const userDoc = await userRef.get();
                            if (userDoc.exists) {
                                const userData = userDoc.data();
                                const currentTotalPoints = userData.totalPoints || 0;
                                const newTotalPoints = currentTotalPoints + points;

                                // Calculate level
                                const calculateLevel = (points) => {
                                    const basePoints = 30; // Points for level 2
                                    const growthRate = 1.1;
                                    let level = 1;
                                    while (points >= basePoints * Math.pow(level, growthRate)) {
                                        level++;
                                    }
                                    return level;
                                };

                                const currentLevel = userData.level || 1;
                                const newLevel = calculateLevel(newTotalPoints);

                                // Prepare updates
                                const updates = {
                                    seasonPoints: admin.firestore.FieldValue.increment(points),
                                    totalPoints: admin.firestore.FieldValue.increment(points),
                                };
                                if (newLevel > currentLevel) {
                                    updates.level = newLevel;
                                    console.log(`User ${userId} leveled up from ${currentLevel} to ${newLevel}.`);
                                }

                                batch.update(userRef, updates);
                            }
                        })()
                    );

                    // Update prediction document with the points gained
                    const predictionRef = db.collection("predictions").doc(predictionId);
                    batch.update(predictionRef, {
                        points: points,
                        actualWinnerName: actualWinnerName,
                        actualPodiumNames: actualPodiumNames,
                        actualFastestLapName: actualFastestLapName,
                    }); // Add the points and the actual results to the prediction document
                }
            });

            // Wait for all async operations to finish
            await Promise.all(updatePromises);

            // Step 5: Mark the race as processed
            batch.update(db.collection("config").doc("lastProcessedRace"), {
                year: raceYear,
                round: raceRound,
            });

            // Commit the batch
            await batch.commit();

            // Step 6: Check if it's the last race of the season
            if (raceResults.is_last_race_of_season === true) {
            //if (true) {
                console.log(`Last race of the season!`);

                // Step 7: Find the user with the most points this season
                const usersQuerySnapshot = await db
                    .collection('users')
                    .orderBy('seasonPoints', 'desc')
                    .limit(1)
                    .get();

                if (usersQuerySnapshot.empty) {
                    throw new Error('No users found to calculate global leaderboard.');
                } else {
                    const topUser = usersQuerySnapshot.docs[0];
                    const topUserId = topUser.id;
                    const topUserData = topUser.data();

                    // Step 8: Update the globalLeaderboardWins and notifyLeaderboardWin fields for the top user
                    const globalLeaderboardWins = (topUserData.globalLeaderboardWins || 0) + 1;

                    await db.collection('users').doc(topUserId).update({
                        globalLeaderboardWins,
                        notifyLeaderboardWin: true,
                    });

                    console.log(`Updated global leaderboard wins and notification for user: ${topUserId}`);

                    // Step 9: Process each league to find the user with the most seasonPoints
                    const leaguesQuerySnapshot = await db.collection('leagues').get();
                    const batch = db.batch(); // Start a batch for league updates

                    for (const leagueDoc of leaguesQuerySnapshot.docs) {
                        const leagueData = leagueDoc.data();
                        const { userIds, id: leagueId, name: leagueName } = leagueData;

                        if (!userIds || userIds.length === 0) {
                            console.log(`League ${leagueId} has no users.`);
                            continue;
                        }

                        // Helper function to split userIds into chunks of 10
                        function chunkArray(array, size) {
                            const result = [];
                            for (let i = 0; i < array.length; i += size) {
                                result.push(array.slice(i, i + size));
                            }
                            return result;
                        }

                        // Fetch users in chunks to handle Firestore limitations
                        const userChunks = chunkArray(userIds, 10);
                        let allLeagueUsers = [];

                        for (const chunk of userChunks) {
                            const snapshot = await db
                                .collection('users')
                                .where(admin.firestore.FieldPath.documentId(), 'in', chunk)
                                .orderBy('seasonPoints', 'desc')
                                .get();

                            if (!snapshot.empty) {
                                allLeagueUsers = allLeagueUsers.concat(
                                    snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }))
                                );
                            }
                        }

                        if (allLeagueUsers.length === 0) {
                            console.log(`No users found in league ${leagueId}.`);
                            continue;
                        }

                        // Sort users locally after fetching all chunks
                        allLeagueUsers.sort((a, b) => b.seasonPoints - a.seasonPoints);

                        const leagueWinner = allLeagueUsers[0];
                        const leagueWinnerId = leagueWinner.id;

                        // Update fields for the league winner
                        const leagueWinnerRef = db.collection('users').doc(leagueWinnerId);
                        const leaguesWon = (leagueWinner.leaguesWon || 0) + 1;
                        const updatedLeagueNameWin = Array.isArray(leagueWinner.leagueNameWin)
                            ? [...leagueWinner.leagueNameWin, leagueName]
                            : [leagueName];

                        batch.update(leagueWinnerRef, {
                            leaguesWon,
                            notifyLeagueWin: true,
                            leagueNameWin: updatedLeagueNameWin,
                        });

                        // Update leaguesFinished field for all users in the league
                        allLeagueUsers.forEach(user => {
                            const leaguesFinished = (user.leaguesFinished || 0) + 1;
                            batch.update(db.collection('users').doc(user.id), { leaguesFinished });
                        });

                        console.log(
                            `Updated leaguesWon for user ${leagueWinnerId} and leaguesFinished for league ${leagueId}.`
                        );
                    }

                    // Commit the batch for league updates
                    await batch.commit();

                    // Step 10: Reset seasonPoints for all users
                    const allUsersSnapshot = await db.collection('users').get();

                    const resetBatch = db.batch();
                    allUsersSnapshot.docs.forEach(doc => {
                        resetBatch.update(doc.ref, { seasonPoints: 0 });
                    });

                    await resetBatch.commit();

                    console.log('Reset seasonPoints for all users.');
                }
            } else {
                console.log('Race is not the last of the season. Season-long challenge continues.');
            }
            console.log(`Successfully processed race for year ${raceYear}, round ${raceRound}`);
        } catch (error) {
            console.error("Error processing race results:", error);
        }

        return null;
    });