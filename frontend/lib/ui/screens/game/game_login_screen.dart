import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/log_in_container.dart';

class GameLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/f1car.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Semi-transparent overlay to make text readable
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              /*Positioned(
                top: 0,
                left: 0,
                child: 
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'GAME',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),),*/
              LogInContainer(isMobile: isMobile)
            ],
          ),
        ),
      ),
    );
  }
}
