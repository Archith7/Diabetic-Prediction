import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ironman/common_widgets/animation_design.dart';
import 'package:ironman/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:ironman/common_widgets/fade_in_animation/fade_in_anmation_controller.dart';
import 'package:ironman/constants/color.dart';
import 'package:ironman/constants/image_strings.dart';
import 'package:ironman/constants/sizes.dart';
import 'package:ironman/constants/text_string.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
 

  @override
  Widget build(BuildContext context) {
  final controller = Get.put(FadeInAnimationController());
  controller.startSplashAnimation();

 

  return Scaffold(
    body: Stack(
    children: [
  
        TFadeInAnimation(
        durationInMs: 1000,
        animate: TAnimatePosition(topBefore: 160
        , topAfter: 180,
         leftAfter: tDefaultSize,
          leftBefore: tDefaultSize),
    child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
          Text(
            tAppName,
            style: TextStyle(
              // fontFamily: GoogleFonts.aBeeZee().fontFamily,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              // Other text style properties
            ),
          ),
         Text(
            tAppTagLine,
            style: TextStyle(
              // fontFamily: GoogleFonts.aBeeZee().fontFamily,
              fontSize: 22,
              // Other text style properties
            ),
          ),
       ],
    ),
    ),
    TFadeInAnimation(
        durationInMs: 1000,
        animate: TAnimatePosition(bottomBefore: 50, 
        bottomAfter: 100),
        child: const Image(image: AssetImage(tSplashImage)),
     ),
    TFadeInAnimation(
        durationInMs: 1000,
        animate: TAnimatePosition(bottomBefore: 40, 
        bottomAfter: 50,
         rightBefore: tDefaultSize, 
         rightAfter: tDefaultSize),
        child: Container(
        width: tSplashContainerSize,
        height: tSplashContainerSize,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: tPrimaryColor
            ),
          ),
        ),
      ],
    ),
  );
 }
}