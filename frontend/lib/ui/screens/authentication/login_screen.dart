import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/core/shared/validators.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/authentication/forgot_password_screen.dart';
import 'package:frontend/ui/screens/authentication/signup_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  final bool isMobile;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var nav = Provider.of<NavigationProvider>(context, listen: false);
    print("Building LoginScreen");
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 40, vertical: widget.isMobile ? 40 : 80),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/logo/logo-detail.png',
                      width: widget.isMobile ? 150 : 200, fit: BoxFit.cover),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: widget.isMobile
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
                          nav.updateIndex(0);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    'Log in to play the F1 Predictions Challenge with your friends and win prizes!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: widget.isMobile ? 30.0 : 50),
                  _buildEmailTF(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  _buildPasswordTF(nav),
                  SizedBox(
                    height: widget.isMobile ? 25 : 50,
                  ),
                  Consumer<AuthService>(builder: (context, auth, child) {
                    return auth.status == Status.Authenticating
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : _buildLogInButton(auth, nav);
                  }),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isMobile ? 14 : 16),
                      ),
                      TextButton(
                        onPressed: () {
                          nav.updateIndex(7);
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: redAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                              fontSize: widget.isMobile ? 14 : 16),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    print("Rebuilding Email TextField");
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
          width: widget.isMobile ? double.infinity : 500,
          child: TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            autofocus: false,
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
            validator: (value) {
              if (!Validators.validateEmail(value!)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(NavigationProvider nav) {
    print("Rebuilding Password TextField");
    return Container(
      width: widget.isMobile ? double.infinity : 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Password',
                style: Globals.kLabelStyle,
              ),
              TextButton(
                onPressed: () {
                  nav.updateIndex(8);
                },
                child: Container(
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
          ),
          const SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: Globals.kBoxDecorationStyle,
            height: 60.0,
            child: TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              autofocus: false,
              cursorColor: Colors.white,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogInButton(AuthService auth, NavigationProvider nav) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      width: widget.isMobile ? double.infinity : 500,
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
              'LOG IN',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1),
            ),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            signIn(auth, nav);
          }
        },
      ),
    );
  }

  void signIn(AuthService auth, NavigationProvider nav) async {
    await auth.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (auth.status == Status.Authenticated) {
      nav.updateIndex(0);
    }

    if (auth.status == Status.Unauthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong email or password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
