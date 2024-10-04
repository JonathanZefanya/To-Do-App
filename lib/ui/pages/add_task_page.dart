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
  List<String> repeatList = ['None', 'Harian', 'Mingguan', 'Bulanan', 'Tahunan'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/nahida.png'),
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
                  'Tambah Jadwal',
                  style: titleStyle,
                ),
                InputField(
                  title: 'Judul',
                  note: 'Masukan Judul.',
                  controller: _titleController,
                ),
                InputField(
                  title: 'Deskripsi',
                  note: 'Masukan Deskripsi.',
                  controller: _noteController,
                ),
                InputField(
                  title: 'Tanggal',
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
                        title: 'Waktu Mulai',
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
                        title: 'Waktu Berakhir',
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
                  title: 'Pengingat',
                  note:
                      '${_selectedRemind == 0 ? 'Tepat Waktu' : '$_selectedRemind Menit Lebih Awal'}  ',
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
                                '${e == 0 ? 'Tepat Waktu' : e}',
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
                  title: 'Pengingat',
                  note: '$_selectedRepeat  ',
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
                                e,
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
                        label: 'Buat Jadwal',
                        color: const Color.fromARGB(255, 46, 232, 0),
                        textStyle: titleStyle.copyWith(color: primaryClr),
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
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                  child: _selectedColor == index ? Icon(Icons.done) : null,
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
      Get.snackbar('Wajib Isi', 'Tolong Isi Semua Field',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  void _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    setState(() {
      if (pickedDate != null) {
        _selectedDate = pickedDate;
      }
    });
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    // ignore: use_build_context_synchronously
    String formatedTime = pickedTime!.format(context);
    setState(() {
      if (isStartTime) {
        _startTime = formatedTime;
      } else if (!isStartTime) {
        _endTime = formatedTime;
      }
    });
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final Color color;
  final TextStyle textStyle;  // Now it expects TextStyle for the button text
  final VoidCallback onTap;

  MyButton({super.key, 
    required this.label,
    required this.color,
    required this.textStyle,  // Changed to TextStyle
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Text(
        label,
        style: textStyle,  // Apply textStyle here
      ),
    );
  }
}
