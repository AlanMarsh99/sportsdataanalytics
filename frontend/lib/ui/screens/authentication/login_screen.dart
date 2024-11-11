import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/screens/authentication/forget_password_screen.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen.dart';
import 'package:frontend/ui/screens/authentication/signup_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
            child: Column(
              children: [
/*Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: Image.asset(
                                      'assets/devalirian_logo.png',
                                      fit: BoxFit.cover,
                                      scale: 14)),*/
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28.0),
                const Text(
                  'Log in to play the F1 Predictions Challenge with your friends and win prizes!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 25.0),
                _buildEmailTF(),
                const SizedBox(
                  height: 30.0,
                ),
                _buildPasswordTF(),
                const SizedBox(
                  height: 15,
                ),
                /* auth.status == Status.Authenticating
                    ? const CircularProgressIndicator(
                        color: secondary,
                      )
                    : */
                _buildLogInButton(/*auth*/),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: redAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,)
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
          child: TextField(
            controller: _emailController,
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

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: Globals.kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Globals.kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: Globals.kHintTextStyle,
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerRight,
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogInButton(/*AuthService auth*/) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
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
              'LOG IN',
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
          signIn(/*auth*/);
        },
      ),
    );
  }

  void signIn(/*AuthService auth*/) async {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.authenticateUser();
    /*await auth.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );*/

    //if (auth.status == Status.Authenticated) {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationScreen()
          //NavigationScreen(),
          ),
    );
    //}

    /*if (auth.status == Status.Unauthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong email or password.'),
          backgroundColor: Colors.red,
        ),
      );
    }*/
  }
}
