import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/screens/game/tutorial_screen.dart';
import 'package:frontend/ui/widgets/carousel_game_options.dart';
import 'package:provider/provider.dart';

class GameFirstScreen extends StatelessWidget {
  const GameFirstScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (auth.status == Status.Authenticated && auth.userApp != null) {
        if (auth.userApp!.firstTimeTutorial) {
          return TutorialScreen();
        } else {
          return F1Carousel();
        }
      } else {
        return TutorialScreen();
      }
    });
  }

  /*return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'GAME',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: isMobile ? 10 : 16),
              //Image
              Container(
                width: double.infinity,
                height: isMobile ? 220 : 500,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/f1car.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'DIVE INTO THE THRILL OF F1 RACING!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Join the excitement of the 2024 Formula 1 season with F1 Prediction Challenge. Test your F1 knowledge by predicting the outcomes of upcoming races and earn points to climb the leaderboard!",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              SizedBox(height: isMobile ? 15 : 30),
              Align(
                alignment: Alignment.center,
                child: _buildTutorialButton(),
              ),
              SizedBox(height: 10),
              Align(alignment: Alignment.center, child: _buildSkipTextButton())
            ],
          ),
        ),
      ),
    );*/
}

  /*Widget _buildTutorialButton() {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(secondary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          child: const Center(
            child: Text(
              'TAKE THE TOUR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TutorialScreen()
                ),
          );
        },
      ),
    );
  }

  Widget _buildSkipTextButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => F1Carousel()),
        );
      },
      child: const Text(
        'Skip',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}*/
