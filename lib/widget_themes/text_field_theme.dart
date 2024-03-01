//Use this inside main Theme to call Light or dark Modes
// import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:ironman/constants/color.dart';

// inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,

class TTextFormFieldTheme { 
  TTextFormFieldTheme._();   

  static InputDecorationTheme lightInputDecorationTheme = const InputDecorationTheme( 
    border: OutlineInputBorder(),  
    prefixIconColor: tSecondaryColor, 
     floatingLabelStyle: TextStyle(
      color: tSecondaryColor
      ), 
       focusedBorder: OutlineInputBorder( 
        borderSide: BorderSide(width: 2, color: tSecondaryColor),  ),  );   
        
        static InputDecorationTheme darkInputDecorationTheme = const InputDecorationTheme( 
          border: OutlineInputBorder(), 
           prefixIconColor: tPrimaryColor,  
           floatingLabelStyle: TextStyle(
            color: tPrimaryColor),  
            focusedBorder: OutlineInputBorder( 
              borderSide: BorderSide(width: 2, color: tPrimaryColor),
                ),  
                ); 
                }