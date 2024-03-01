import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ironman/constants/image_strings.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _passwordObscured = true;
  bool _confirmPasswordObscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int c=0;

   void _togglePasswordVisibility() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordObscured = !_confirmPasswordObscured;
    });
  }
  // final EmailOTP myauth = EmailOTP();


Future<void> _sendMobileOTP(BuildContext context) async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print('Phone number verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) async {
         
            Get.toNamed(
  '/verify_phone_otp',
  arguments: {
    'verificationId': verificationId,
    'phoneNumber': phoneController.text,
    'name': nameController.text,
    'age': ageController.text,
    'email': emailController.text,
    'password': passwordController.text, // Pass the EmailOTP instance
  },
);

        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oops, OTP send failed'),
          ),
      );
      print('Error sending OTP: $e');
    }
  }


Future<void> _sendEmailOTP(BuildContext context) async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Create an instance of EmailOTP
      EmailOTP myauth = EmailOTP();
      myauth.setConfig(
        appEmail: "me@rohitchouhan.com",
        appName: "Email OTP",
        userEmail: emailController.text,
        otpLength: 6,
        otpType: OTPType.digitsOnly,
      );

      // Send OTP
      if (await myauth.sendOTP() == true) {
        
        Get.toNamed(
  '/verify_email_otp',
  arguments: {
    'phoneNumber': phoneController.text,
    'name': nameController.text,
    'age': ageController.text,
    'email': emailController.text,
    'password': passwordController.text,
    'emailOTPInstance': myauth, // Pass the EmailOTP instance
  },
);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oops, OTP send failed'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error sending OTP: $e');
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
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage(tWelcomeScreenImage),
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    const Text(
                      tSignUpTitle,
                      style: TextStyle(
                        fontFamily: "Your Font Family", // Replace with your actual font family
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Text(
                      tSignUpSubTitle,
                      style: TextStyle(
                        fontFamily: "Your Font Family", // Replace with your actual font family
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Form
                Container(
                  padding: const EdgeInsets.symmetric(vertical: tDefaultSize - 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: tDefaultSize - 2),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: tFullName,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                         const SizedBox(height: tDefaultSize - 20),
                        TextFormField(
                          controller: ageController,
                            keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: Age,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                        ),
                        const SizedBox(height: tDefaultSize - 20),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: tEmail,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: tDefaultSize - 20),
                        TextFormField(
                          controller: phoneController,
                            keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: tPhoneNo,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                        ),
                        const SizedBox(height: tDefaultSize - 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _passwordObscured,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint),
                            labelText: tPassword,
                            // hintText: tPassword,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: _passwordObscured
                                   ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                                          ),
                          ),
                        ),
                        const SizedBox(height: tDefaultSize - 20),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _confirmPasswordObscured,
                          decoration: InputDecoration(
                            labelText: tConformPassword,
                          border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.fingerprint),
                            suffixIcon: IconButton(
                            onPressed: _toggleConfirmPasswordVisibility,
                            icon: _confirmPasswordObscured
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          ),
                        ),
                        const SizedBox(height: tDefaultSize - 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(
                              // width: double.infinity,
                              // child: 
                              ElevatedButton(
                                onPressed: () {
                                  //  _sendMobileOTP(context);
                                  c=0;
                                  _validateForm(c);
                                },
                                 style: ButtonStyle(
                                 fixedSize: MaterialStateProperty.all(const Size(140, 50)), // Adjust the width and height as needed
                                 // You can customize other button styles as well
                                   ),
                                child: Text(mobileverify.toUpperCase()),
                              ),
                              const SizedBox(width: 40,),
                              ElevatedButton(
                                onPressed: () {
                                  // _sendEmailOTP(context);
                                  c=1;
                                  _validateForm(c);
                                },
                                style: ButtonStyle(
                                 fixedSize: MaterialStateProperty.all(const Size(140, 50)), // Adjust the width and height as needed
                                 // You can customize other button styles as well
                                   ),
                                child: Text(emailverify.toUpperCase()),
                              ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer

                Column(children: [ TextButton(onPressed: () {
                         Get.to(() => const LoginPage()); },
                      child: Text.rich(TextSpan(text: AlreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.bodyText2,
                          children: const [TextSpan(text: tLogin,
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
   void _validateForm(int c) {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      if (_validateFullName() &&
          _validateEmail() &&
          _validatePhoneNo() &&
          _validatePassword() &&
          _validateConfirmPassword()) {
            if(c==1){
         _sendEmailOTP(context);}
        else{
          _sendMobileOTP(context);
        }
      }
    }
  }

  bool _validateFullName() {
    if (nameController.text.isEmpty) {
      _showSnackBar('Please enter your full name');
      return false;
    }
    return true;
  }

  bool _validateEmail() {
    if (!emailController.text.endsWith('@gmail.com')) {
      _showSnackBar('Please enter a valid Gmail address');
      return false;
    }
    return true;
  }

  bool _validatePhoneNo() {
    if (phoneController.text.length != 10) {
      _showSnackBar('Phone number should be 10 digits');
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    if (passwordController.text.isEmpty) {
      _showSnackBar('Enter Password');
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      _showSnackBar('Enter Confirm Password');
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return false;
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

