import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ironman/common_widgets/form/form_header_widget.dart';
import 'package:ironman/constants/image_strings.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      // Password reset email sent successfully
      print("Password reset email sent to ${_emailController.text}");
    } catch (e) {
      // An error occurred
      print("Error sending password reset email: $e");
    }
  }

 @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                FormHeaderWidget(
                  image: tForgotPasswordImage,
                  title: tForgetPassword.toUpperCase(),
                  subTitle: '',
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            label: Text(tEmail),
                            hintText: tEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity, 
                          child:  ElevatedButton(
                            onPressed: _resetPassword,
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(const Size(140, 50)), 
                                
                                  ),
                           child: const Text("Reset Password"),
                          ),
                       ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}