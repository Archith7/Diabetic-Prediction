import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ironman/common_widgets/animation_design.dart';
import 'package:ironman/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:ironman/common_widgets/fade_in_animation/fade_in_anmation_controller.dart';
import 'package:ironman/constants/color.dart';
import 'package:ironman/constants/image_strings.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';
import 'package:ironman/login_page.dart';
import 'package:ironman/signup_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startAnimation();

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor,
      body: Stack(
        children :[
          TFadeInAnimation(
            durationInMs: 1200,
            animate: TAnimatePosition(
              bottomAfter: 0 ,
              bottomBefore: -100,
              leftAfter: 0 ,
              leftBefore: 0 ,
              rightAfter: 0 ,
              rightBefore: 0 ,
              topAfter: 0 ,
              topBefore:0 ),
            child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: const AssetImage(tWelcomeScreenImage), height: height * 0.6),
            Column(
              children: [
               const Text(
                      tAppName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),

                Text(tWelcomeSubTitle,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => LoginPage()),
                    child: Text(tLogin.toUpperCase()),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => SignupPage()),
                    child: Text(tSignup.toUpperCase()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
        ),
        ],
      ),
   );
  }
}