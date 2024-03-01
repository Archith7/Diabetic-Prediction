import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_otp/email_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';
import 'package:ironman/success_page.dart';

class VerifyEmailOTPPage extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  VerifyEmailOTPPage({super.key});

  Future<void> _verifyOTPAndCreateUser(
      BuildContext context,
      String name,
      String age,
      String email,
      String password,
      EmailOTP emailOTPInstance, // Include EmailOTP instance as parameter
      String phoneNumber) async {
    try {
      // Verify OTP using the EmailOTP instance
      if (await emailOTPInstance.verifyOTP(otp: otpController.text)) {
        // OTP verification successful, proceed to create user

        // Create user in Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;

        // Save user information to Firestore
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': name,
            'age': age,
            'email': email,
            'phoneNumber': phoneNumber, 
           
          });

          
            Get.to(() =>  SuccessPage(
              message: 'Signup successful!',
            ));
        } else {
          print('User creation failed.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User creation failed. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('Invalid OTP.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error verifying OTP and creating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The email address is already in use by another account.'),
            duration: Duration(seconds: 3),
          ),
        );

    }
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    final String name = args['name'];
    final String age = args['age'];
    final String email = args['email'];
    final String password = args['password'];
    final String phoneNumber =
        args['phoneNumber']; 
    final EmailOTP emailOTPInstance =
        args['emailOTPInstance']; 

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tOtpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 40.0),
            const Text("$tOtpMessage \nat your email", textAlign: TextAlign.center),
            const SizedBox(height: 30.0),
            
            OtpTextField(
                keyboardType: TextInputType.number,mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,fillColor: Colors.black.withOpacity(0.1),
                filled: true,onSubmit: (otp){otpController.text = otp ;print("$otp");
                }),


            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: ()
               {
                 _verifyOTPAndCreateUser(
                  context,
                  name,
                  age,
                  email,
                  password,
                  emailOTPInstance,
                  phoneNumber,
                );
               }, 
              child: const Text(verify)),
            ),
          ],
        ),
      ),
    );
  }
}
