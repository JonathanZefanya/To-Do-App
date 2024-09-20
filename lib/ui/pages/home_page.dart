import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/controllers/themeController.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/pages/notification_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'package:todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController.getTask();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final themeServices = Get.find<ThemeServices>();
    final ThemeController themeController = Get.find();
    // final ThemeServices themeServices = Get.find();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
            ),
            SizedBox(
              width: 20,
            )
          ],
          leading: Obx(() {
            return IconButton(
              onPressed: () {
                themeController.switchTheme();
              },
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round_outlined,
              ),
            );
          }),
        ),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(
              height: 6,
            ),
            _showTasks()
          ],
        ));
  }

  _addTaskBar() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(() => const AddTaskPage());
              })
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _taskController.getTask();
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        initialSelectedDate: _selectedDate,
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w600)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTask();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemCount: _taskController.taskList.length,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];
                // var hour = task.startTime.toString().split(':')[0];
                // var minutes = task.startTime.toString().split(':')[1];
                // var date = DateFormat.jm().parse(task.startTime!);
                // var myTime = DateFormat('HH:mm').format(date);
                NotifyHelper().scheduledNotification(
                    // int.parse(myTime.toString().split(':')[0]),
                    // int.parse(myTime.toString().split(':')[1]),
                    9,
                    50,
                    task);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          showBottomSheet(context, task);
                        },
                        child: TaskTile(task),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
    // return Expanded(
    //     child: GestureDetector(
    //   onTap: () {
    //     showBottomSheet(context, task);
    //   },
    //   child: TaskTile(task),
    // ));

    //  Expanded(child: Obx(() {
    //   if (_taskController.taskList.isEmpty) {

    //   } else {
    //     return Container();
    //   }
    // }));
  }

  String convertTo24HourFormat(String time) {
    // Handle both 12-hour (AM/PM) and 24-hour formats
    List<String> timeParts = time.split(' ');

    String timeComponent = timeParts[0]; // "11:30"
    String period =
        timeParts.length > 1 ? timeParts[1].toUpperCase() : ''; // "AM" or "PM"

    List<String> timeComponentParts = timeComponent.split(':');
    int hour = int.parse(timeComponentParts[0]);
    int minute = int.parse(timeComponentParts[1]);

    // If the time includes AM/PM, convert it
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '$hour:$minute'; // Return time in 24-hour format
  }

  _noTask() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Ensure scroll physics is enabled
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? SizedBox(height: 6)
                    : SizedBox(height: 220),
                SvgPicture.asset(
                  color: primaryClr.withOpacity(0.6),
                  'images/task.svg',
                  height: 90,
                  semanticsLabel: 'Task',
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    textAlign: TextAlign.center,
                    style: subTitleStyle,
                    'You do not have any tasks yet!\n Add new tasks to make your days productive.',
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? SizedBox(height: 120)
                    : SizedBox(height: 170),
              ],
            ),
          ),
        )
      ],
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required clr,
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
                        ? Colors.grey[600]
                        : Colors.grey[300]
                    : clr),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 4),
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
                height: 4,
                width: SizeConfig.screenWidth * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey[600]!),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      TaskController().markAsCompleted(task.id!);
                      _taskController.getTask();
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  TaskController().deleteTask(task: task);
                  _taskController.getTask();
                  Get.back();
                },
                clr: Colors.red[300]),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
  }
}
