
import 'package:flutter/material.dart';
import 'package:ironman/constants/color.dart';
import 'package:ironman/constants/sizes.dart';

/*-- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
TElevatedButtonTheme._(); //To avoid creating instances


/*-- Light Theme */

static final lightElevatedButtonTheme = ElevatedButtonThemeData( style: ElevatedButton.styleFrom(
    elevation: 0,
    shape: const RoundedRectangleBorder(),
    foregroundColor: tWhiteColor,
    backgroundColor: tSecondaryColor,
    side: const BorderSide (color: tSecondaryColor),
    padding: const EdgeInsets.symmetric(vertical: tButtonHeight), ),
 ); 
/*  -- Dark Theme -- */

static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom( elevation: 0,
    shape: const RoundedRectangleBorder(),
    foregroundColor: tSecondaryColor,
    backgroundColor: tWhiteColor,
    side: const BorderSide (color: tWhiteColor),
    padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
  ),
);
}