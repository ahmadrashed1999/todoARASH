import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/main.dart';
import 'package:testapp/ui/pages/home_page.dart';
import 'package:testapp/ui/widgets/button.dart';
import 'package:testapp/ui/widgets/input_field.dart';

import '../../loacal/local_controller.dart';
import '../size_config.dart';
import '../theme.dart';

class OnChoose extends StatefulWidget {
  OnChoose({Key? key}) : super(key: key);

  @override
  State<OnChoose> createState() => _OnChooseState();
}

class _OnChooseState extends State<OnChoose> {
  var _selectedRemind = 1;
  TextEditingController _nameController = TextEditingController();

  var imgList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
  @override
  Widget build(BuildContext context) {
    String lancode = 'en';
    SizeConfig().init(context);
    MyLoaclController controller = Get.find();
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  width: 120,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'welcome'.tr,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: primaryClr,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                    title: "name".tr,
                    hint: "hintname".tr,
                    controller: _nameController),
                InputField(
                  title: 'av'.tr,
                  hint: '$_selectedRemind',
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Colors.blueGrey,
                        items: imgList
                            .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                                value: value.toString(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Image.asset(
                                      'images/$value.png',
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(
                          height: 0,
                        ),
                        style: subtitleStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRemind = int.parse(newValue!);
                          });
                        },
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    langButton(
                        lable: 'English',
                        onTap: () {
                          setState(() {
                            lancode = 'en';
                          });
                          controller.changeLocal('en');
                        },
                        clr: Colors.green),
                    langButton(
                        lable: 'عربي',
                        onTap: () {
                          setState(() {
                            lancode = 'ar';
                          });
                          controller.changeLocal('ar');
                        },
                        clr: Colors.green),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(
                    lable: "continue".tr,
                    onTap: () {
                      prefs.setString('lang', lancode);

                      _validateDate();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_nameController.text.isNotEmpty) {
      prefs.setString('img', _selectedRemind.toString());
      prefs.setString('name', _nameController.text);
      Get.offAll(() => HomePage());
    } else if (_nameController.text.isEmpty) {
      Get.snackbar('requier'.tr, 'requierd'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print('=========================================');
    }
  }

  langButton({
    required String lable,
    required Function() onTap,
    required Color clr,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        width: SizeConfig.screenWidth * 0.4,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: clr,
        ),
        child: Center(
            child: Text(
          lable,
          style: titleStyle,
        )),
      ),
    );
  }
}
