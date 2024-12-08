import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/core/shared/validators.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  final bool isMobile;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _repeatPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var nav = Provider.of<NavigationProvider>(context, listen: false);
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
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/logo/logo-detail.png',
                        width: widget.isMobile ? 150 : 200, fit: BoxFit.cover),
                    const SizedBox(
                      height: 30,
                    ),
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
                            nav.updateIndex(6);
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Create an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildEmailTF(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _buildUsernameTF(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTF(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _buildRepeatPasswordTF(),
                    SizedBox(
                      height: widget.isMobile ? 25 : 50,
                    ),
                    Consumer<AuthService>(builder: (context, auth, child) {
                      return auth.status == Status.Authenticating
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : _buildSignUpButton(auth, nav);
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
          width: widget.isMobile ? double.infinity : 500,
          child: TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
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
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Username',
          style: Globals.kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Globals.kBoxDecorationStyle,
          height: 60.0,
          width: widget.isMobile ? double.infinity : 500,
          child: TextFormField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your username',
              hintStyle: Globals.kHintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (!Validators.validateName(value)) {
                return 'Invalid username. Length min. 4, max. 12 characters';
              }
              return null;
            },
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
          width: widget.isMobile ? double.infinity : 500,
          child: TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
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
              hintText: 'Enter a password',
              hintStyle: Globals.kHintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              if (!Validators.isAlphanumeric(value)) {
                return 'Password must contain both letters and numbers';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Repeat password',
          style: Globals.kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Globals.kBoxDecorationStyle,
          height: 60.0,
          width: widget.isMobile ? double.infinity : 500,
          child: TextFormField(
            controller: _repeatPasswordController,
            focusNode: _repeatPasswordFocusNode,
            cursorColor: Colors.white,
            obscureText: !_repeatPasswordVisible,
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
                  _repeatPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _repeatPasswordVisible = !_repeatPasswordVisible;
                  });
                },
              ),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter the password',
              hintStyle: Globals.kHintTextStyle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please repeat the password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(AuthService auth, NavigationProvider nav) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: widget.isMobile ? double.infinity : 500,
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
              'SIGN UP',
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
          if (_formKey.currentState!.validate()) {
            try {
              // Query Firestore to check if the username or email is already taken.
              final usersCollection =
                  FirebaseFirestore.instance.collection('users');

              // Check for username.
              final usernameQuery = await usersCollection
                  .where('username', isEqualTo: _usernameController.text.trim())
                  .get();
              if (usernameQuery.docs.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Error: Username is already taken'),
                      backgroundColor: secondary),
                );
                return;
              }

              // Check for email.
              final emailQuery = await usersCollection
                  .where('email', isEqualTo: _emailController.text.trim())
                  .get();
              if (emailQuery.docs.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: Email is already registered'),
                    backgroundColor: secondary,
                  ),
                );
                return;
              }

              // Proceed with sign-up if username and email are unique.
              await auth.signUp(context, _emailController.text,
                  _usernameController.text, _passwordController.text);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account created successfully!')),
              );

              // Navigate to the next screen.
              nav.updateIndex(0);
            } catch (e) {
              // Handle errors and inform the user.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: secondary),
              );
            }
          }
        },
      ),
    );
  }
}
