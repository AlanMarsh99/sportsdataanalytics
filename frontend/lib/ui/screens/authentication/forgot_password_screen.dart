import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/core/shared/validators.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key, required this.isMobile})
      : super(key: key);

  final bool isMobile;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: Form(
            key: _formKey,
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
                        nav.setRoute('login');
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
                Consumer<AuthService>(builder: (context, auth, child) {
                  return _buildSendButton(auth, nav);
                })
              ],
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

  Widget _buildSendButton(AuthService auth, NavigationProvider nav) {
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
          if (_formKey.currentState!.validate()) {
            sendInstructions(auth, nav);
          }
        },
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void sendInstructions(AuthService auth, NavigationProvider nav) async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      showSnackbar(context, 'Please, enter your email.');
      return;
    }
    try {
      await auth.resetPassword(email);
      showSnackbar(context, 'Email sent successfully!');
      nav.setRoute('login');
    } catch (e) {
      showSnackbar(context, 'Error: ${e.toString()}');
    }
  }
}
