import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/db/db_helper.dart';
import 'package:testapp/loacal/lacal.dart';
import 'package:testapp/loacal/local_controller.dart';
import 'package:testapp/services/notification_services.dart';
import 'package:testapp/services/theme_services.dart';
import 'package:testapp/ui/pages/notification_screen.dart';
import 'package:testapp/ui/pages/onchoose.dart';
import 'package:testapp/ui/theme.dart';
import 'ui/pages/home_page.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyLoaclController());

    return GetMaterialApp(
        theme: Themes.light,
        darkTheme: Themes.dark,
        locale: Get.deviceLocale,
        translations: Mylocal(),
        themeMode: ThemeServices().theme,
        title: 'Todo ARSH',
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          splash: 'images/logo.png',
          duration: 1500,
          splashTransition: SplashTransition.rotationTransition,
          nextScreen: 
          prefs.getString('name') == null ? OnChoose() : HomePage(),
        ));
  }
}
