import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ironman/constants/image_strings.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';
import 'package:ironman/forgot_pass.dart';
import 'package:ironman/signup_page.dart';
import 'success_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;
  void _toggleObscureText() {
  setState(() {
    _isObscured = !_isObscured;
  });
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;



    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage(tWelcomeScreenImage),
                      height: size.height * 0.2,
                    ),
                    const Text(
                      tLoginTitle,
                      style: TextStyle(
                        fontFamily: "Your Font Family", // Replace with your actual font family
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Text(
                      tLoginSubTitle,
                      style: TextStyle(
                        fontFamily: "Your Font Family", // Replace with your actual font family
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Form
                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: tFormHeight - 1),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: tEmail,
                            hintText: tEmail,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: tFormHeight - 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint),
                            labelText: tPassword,
                            hintText: tPassword,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: _toggleObscureText,
                              icon: _isObscured
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                        ),
                        const SizedBox(height: tFormHeight - 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // ForgetPasswordScreen.buildShowModalBottomSheet(context);
                              // Navigator.pushReplacementNamed(context,'/forgotpass');
                              Get.to(()=>const ForgotPasswordPage());
                            },
                            child: const Text(tForgetPassword),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                               _signInWithEmailAndPassword();
                            },
                            child: Text(tLogin.toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to SignUpScreen
                        // Navigator.pushReplacementNamed(context,'/SignupPage');
                        Get.to(() => const SignupPage());
                      },
                      child: Text.rich(
                        TextSpan(
                          text: tDontHaveAnAccount,
                          style: Theme.of(context).textTheme.bodyText2,
                          children: const [
                            TextSpan(
                              text: tSignup,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user != null) {
        // Login successful, navigate to the success page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SuccessPage(
              message: 'Login successful!',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }
}
