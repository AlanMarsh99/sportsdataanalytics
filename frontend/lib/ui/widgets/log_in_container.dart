import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/screens/authentication/signup_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class LogInContainer extends StatelessWidget {
  final bool isMobile;

  LogInContainer({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile
          ? MediaQuery.of(context).size.width * 0.7
          : MediaQuery.of(context).size.width * 0.55,
      height: isMobile ? 180 : 200,
      decoration: BoxDecoration(
        color: primary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 8, horizontal: isMobile ? 16 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Log in or sign up to make predictions and compete with your friends!",
              style:
                  TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 18),
            ),
            SizedBox(
              height: isMobile ? 30 : 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width:
                      isMobile ? 110 : MediaQuery.of(context).size.width * 0.15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(secondary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      NavigationProvider nav =
                          Provider.of<NavigationProvider>(context, listen: false);
                      nav.setRoute('login');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'LOG IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 20 : 50),
                Container(
                  width:
                      isMobile ? 110 : MediaQuery.of(context).size.width * 0.15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(secondary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                     NavigationProvider nav =
                          Provider.of<NavigationProvider>(context, listen: false);
                      nav.setRoute('signup');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
