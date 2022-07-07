import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/controllers/task_controller.dart';
import 'package:testapp/loacal/lacal.dart';
import 'package:testapp/main.dart';
import 'package:testapp/models/task.dart';
import 'package:testapp/services/notification_services.dart';
import 'package:testapp/services/theme_services.dart';
import 'package:testapp/ui/pages/add_task_page.dart';
import 'package:testapp/ui/pages/editPage.dart';
import 'package:testapp/ui/pages/notification_screen.dart';
import 'package:testapp/ui/size_config.dart';
import 'package:testapp/ui/theme.dart';
import 'package:testapp/ui/widgets/button.dart';
import 'package:testapp/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:testapp/ui/widgets/task_tile.dart';
import 'add_task_page.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestAndroidPermission();
    notifyHelper.requestIOSPermission();
    notifyHelper.initializeNotification();
    _taskController.getTask();
    initializeDateFormatting();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  var img = prefs.getString('img');
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(context),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[700],
          onPressed: () {
            Get.bottomSheet(SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: SizeConfig.screenWidth,
                color: Get.isDarkMode ? darkHeaderClr : Colors.white,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'confirm'.tr,
                      style: subheadingStyle,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBottmSheet2(
                            lable: 'delete'.tr,
                            onTap: () {
                              notifyHelper.cancelaLLNotification();
                              _taskController.deleteAllTask();
                              Get.back();
                            },
                            clr: Colors.red),
                        _buildBottmSheet2(
                            lable: 'cancel'.tr,
                            onTap: () {
                              Get.back();
                            },
                            clr: Colors.green),
                      ],
                    )
                  ],
                ),
              ),
            ));
          },
          child: Icon(
            Icons.cleaning_services_outlined,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(
              height: 8,
            ),
            _showTaskes(),
            //_addTaskBar(),
            //_addDateBar(),
            //const SizedBox(height: 8),
            //_showTaskes(),
          ],
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0,
      // centerTitle: true,
      backgroundColor: context.theme.backgroundColor,
      actions: [
        InkWell(
          onTap: () {
            Get.to(() => EditPage());
          },
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('images/$img.png'),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10, right: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd('ln'.tr).format(DateTime.now()),
              style: subheadingStyle,
            ),
            Text(
              'today'.tr,
              style: headingStyle,
            )
          ],
        ),
        MyButton(
            lable: 'add'.tr,
            onTap: () async {
              await Get.to(() => const AddTaskPage());
            }),
      ]),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        locale: prefs.getString('lang')!,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                color: Colors.grey, fontSize: 8, fontWeight: FontWeight.w600)),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onrefresh() async {
    _taskController.getTask();
  }

  _showTaskes() {
    return Expanded(
     
      child: Obx(
        (() {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              onRefresh: _onrefresh,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (context, i) {
                  var task = _taskController.taskList[i];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == 'Weakly' &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      (task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day)) {
                    var date = DateFormat.jm().parse(task.startTime!);
                    var myTime = DateFormat('HH:mm').format(date);
                    notifyHelper.scheduledNotification(
                        int.parse(myTime.toString().split(':')[0]),
                        int.parse(myTime.toString().split(':')[1]),
                        task);
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      duration: Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              _showBottmSheet(
                                context,
                                task,
                              );
                            },
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: _taskController.taskList.length,
              ),
            );
          }
        }),
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onrefresh,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: SizeConfig.orientation == Orientation.landscape
                          ? Axis.horizontal
                          : Axis.vertical,
                      children: [
                        SizeConfig.orientation == Orientation.landscape
                            ? const SizedBox(
                                height: 6,
                              )
                            : const SizedBox(
                                height: 220,
                              ),
                        SvgPicture.asset(
                          'images/task.svg',
                          color: primaryClr.withOpacity(0.5),
                          height: 100,
                          semanticsLabel: 'Task',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'notask'.tr,
                            style: body2Style,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizeConfig.orientation == Orientation.landscape
                            ? const SizedBox(
                                height: 120,
                              )
                            : const SizedBox(
                                height: 180,
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showBottmSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ), // BoxDecoration
              ),
            ),
            const SizedBox(height: 20),
            task.isCompleted == 1
                ? Container()
                : _buildBottmSheet(
                    lable: 'taskCompleted'.tr,
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markAsComplemeted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottmSheet(
                lable: 'deleteTask'.tr,
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTask(task);
                  Get.back();
                },
                clr: Colors.red[400]!),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottmSheet(
                lable: 'cancel'.tr,
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
            SizedBox(height: 20),
          ],
        ), // Column
      ),
    ));
  }

  _buildBottmSheet(
      {required String lable,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          lable,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _buildBottmSheet2({
    required String lable,
    required Function() onTap,
    required Color clr,
  }) {
    return GestureDetector(
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
