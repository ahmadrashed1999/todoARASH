import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:testapp/controllers/task_controller.dart';
import 'package:testapp/db/db_helper.dart';
import 'package:testapp/ui/pages/home_page.dart';
import 'package:testapp/ui/theme.dart';
import 'package:testapp/ui/widgets/button.dart';

import '../../main.dart';
import '../../models/task.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectdRepeat = 'none';
  List<String> repeatList = ['None', 'Daily', 'Weakly', 'Monthly'];
  int _selectedColor = 0;
  @override
  void initState() {
    // TODO: implement initState
  }
  var img = prefs.getString('img');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,

      appBar: _appBar(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'ah'.tr,
                  style: headingStyle,
                ),
                InputField(
                  title: 'title'.tr,
                  hint: 'hint'.tr,
                  controller: _titleController,
                ),
                InputField(
                  title: 'note'.tr,
                  hint: 'hint'.tr,
                  controller: _noteController,
                ),
                InputField(
                  title: 'date'.tr,
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                      onPressed: () => _getDateFromUser(),
                      icon: const Icon(Icons.calendar_today_outlined)),
                ), // InputField// InputF// InputField
                Row(children: [
                  Expanded(
                    child: InputField(
                      title: 'stime'.tr,
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(
                              isStartTime: true,
                            );
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'etime'.tr,
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(
                            isStartTime: false,
                          );
                        },
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Row
                ]), // Column
                InputField(
                  title: 'remind'.tr,
                  hint: '$_selectedRemind ' + 'early'.tr,
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Colors.blueGrey,
                        items: remindList
                            .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: const TextStyle(
                                    color: Colors.white,
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
                InputField(
                  title: 'repeat'.tr,
                  hint: _selectdRepeat,
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Colors.blueGrey,
                        items: repeatList
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.white,
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
                            _selectdRepeat = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _colorPalette(),
                    MyButton(
                        lable: 'creat'.tr,
                        onTap: () {
                          _validateDate();
                        }),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ), // SingleChildScrollView
        ),
      ), // Container
    ); // Scaffold
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios_outlined,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      // centerTitle: true,
      backgroundColor: context.theme.backgroundColor,
      actions: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('images/$img.png'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'color'.tr,
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List.generate(
          6,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                child: _selectedColor == index
                    ? Icon(
                        Icons.done_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : index == 2
                            ? bluesky
                            : index == 3
                                ? pinky
                                : index == 4
                                    ? yellow
                                    : orangeClr,
                radius: 14,
              ),
            ),
          ),
        )),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.offAll(() => HomePage());
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('requierd'.tr, 'requierd'.tr,
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

  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectdRepeat,
      color: _selectedColor,
    ));
    print("$value");
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else {}
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );

    if (_pickedTime != null) {
      String _formaTtedTime = _pickedTime.format(context);

      if (isStartTime) {
        setState(() {
          _startTime = _formaTtedTime;
        });
      } else if (!isStartTime) {
        setState(() {
          _endTime = _formaTtedTime;
        });
      } else {
        print('error');
      }
    } else {}
  }
}
