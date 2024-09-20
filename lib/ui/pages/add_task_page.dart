import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

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
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Add Task',
                  style: titleStyle,
                ),
                InputField(
                  title: 'Title',
                  note: 'Enter title here.',
                  controller: _titleController,
                ),
                InputField(
                  title: 'Note',
                  note: 'Enter note here.',
                  controller: _noteController,
                ),
                InputField(
                  title: 'Date',
                  note: DateFormat.yMd().format(_selectedDate),
                  myWidget: IconButton(
                      onPressed: () {
                        _getDateFromUser();
                      },
                      icon: Icon(Icons.calendar_today_outlined)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        note: _startTime,
                        myWidget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_rounded),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        note: _endTime,
                        myWidget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(Icons.access_time_rounded),
                        ),
                      ),
                    )
                  ],
                ),
                InputField(
                  title: 'Remind',
                  note:
                      '${_selectedRemind == 0 ? 'On Time' : _selectedRemind.toString() + ' minutes early'}  ',
                  myWidget: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.blueGrey,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      ),
                      elevation: 4,
                      iconSize: 32,
                      underline: Container(
                        height: 0,
                      ),
                      items: remindList
                          .map((e) => DropdownMenuItem<String>(
                              alignment: AlignmentDirectional.bottomStart,
                              value: e.toString(),
                              child: Text(
                                '${e == 0 ? 'On Time' : e}',
                                style: TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      style: subTitleStyle,
                      onChanged: (value) {
                        setState(() {
                          _selectedRemind = int.parse(value!);
                        });
                      }),
                ),
                InputField(
                  title: 'Remind',
                  note: '${_selectedRepeat}  ',
                  myWidget: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.blueGrey,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      ),
                      elevation: 4,
                      iconSize: 32,
                      underline: Container(
                        height: 0,
                      ),
                      items: repeatList
                          .map((e) => DropdownMenuItem<String>(
                              alignment: AlignmentDirectional.bottomStart,
                              value: e.toString(),
                              child: Text(
                                '$e',
                                style: TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      style: subTitleStyle,
                      onChanged: (value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    colorPalette(),
                    MyButton(
                        label: 'Create Task',
                        onTap: () {
                          _validateData();
                        })
                  ],
                )
              ],
            ),
          )),
    );
  }

  Column colorPalette() {
    return Column(
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        Wrap(
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: _selectedColor == index ? Icon(Icons.done) : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _addTasksToDb() async {
    int? value = await _taskController.addTask(
        task: Task(
            title: _titleController.text,
            note: _noteController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat));
    print(value);
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required field', 'please fill all the required fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  void _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2040),
    );
    setState(() {
      if (_pickedDate != null) {
        _selectedDate = _pickedDate;
      }
    });
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    String _formatedTime = _pickedTime!.format(context);
    setState(() {
      if (_pickedTime != null && isStartTime) {
        _startTime = _formatedTime;
      } else if (_pickedTime != null && !isStartTime) {
        _endTime = _formatedTime;
      }
    });
  }
}
