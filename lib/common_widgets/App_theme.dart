import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void toggleTheme() {
    themeMode.value =
        (themeMode.value == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(themeMode.value);
  }
}