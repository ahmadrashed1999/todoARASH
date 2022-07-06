import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/main.dart';

class MyLoaclController extends GetxController {
  MyLoaclController();
  void changeLocal(code) {
    Locale locale = code == 'ar' ? Locale('ar', 'SA') : Locale('en', 'US');
    Get.updateLocale(locale);
    code == 'ar'
        ? prefs.setString("lang", "ar")
        : prefs.setString("lang", "en");
  }
}
