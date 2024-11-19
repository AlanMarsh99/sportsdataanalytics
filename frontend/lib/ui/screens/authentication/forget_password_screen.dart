import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool isMobile = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isMobile = Responsive.isMobile(context);
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkGradient, lightGradient],
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: /*Consumer<AuthService>(builder: (context, auth, child) {
          return*/
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              children: [
                Image.asset('assets/logo/logo-detail.png',
                    width: isMobile ? 150 : 200, fit: BoxFit.cover),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                _buildEmailTF(),
                const SizedBox(
                  height: 15,
                ),
                /* auth.status == Status.Authenticating
                    ? const CircularProgressIndicator(
                        color: secondary,
                      )
                    : */
                _buildSendButton(/*auth*/),
              ],
            ),
          ),
        )
        //}),

        );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: Globals.kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Globals.kBoxDecorationStyle,
          height: 60.0,
          width: isMobile ? double.infinity : 500,
          child: TextField(
            controller: _emailController,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your email',
              hintStyle: Globals.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(/*AuthService auth*/) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: isMobile ? double.infinity : 500,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(secondary),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ))),
        child: Container(
          padding: const EdgeInsets.all(2),
          child: const Center(
            child: Text(
              'SEND INSTRUCTIONS',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1),
            ),
          ),
        ),
        onPressed: () async {
          // Check if the passwords match

          signUp(/*auth*/);
        },
      ),
    );
  }

  void signUp(/*AuthService auth*/) async {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.authenticateUser();
    /*await auth.signUp(
      _emailController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text,
    );*/

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationScreen()
          //NavigationScreen(),
          ),
    );
  }
}
