import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:testapp/controllers/task_controller.dart';
import 'package:testapp/ui/theme.dart';
import 'package:testapp/ui/widgets/button.dart';

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
  List<String> repeatList = ['None', 'Dealy', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,

      appBar: _appBar(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add Task',
                  style: headingStyle,
                ),
                InputField(
                  title: 'Title',
                  hint: 'Enter something',
                  controller: _titleController,
                ),
                InputField(
                  title: 'Note',
                  hint: 'Enter something',
                  controller: _noteController,
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today_outlined)),
                ), // InputField// InputF// InputField
                Row(children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {},
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
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Row
                ]), // Column
                InputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minute early',
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
                  title: 'Repeat',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(
                        lable: 'Create Task',
                        onTap: () {
                          Get.back();
                        }),
                  ],
                ),
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
          radius: 18,
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Column _colorPalette() {
    return Column(
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List.generate(
          3,
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
                        : orangeClr,
                radius: 16,
              ),
            ),
          ),
        )),
      ],
    );
  }
}
