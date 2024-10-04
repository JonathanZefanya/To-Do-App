import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    getTask(); // Fetch the tasks when the controller is initialized
  }

  final taskList = <Task>[].obs;
  Future<void> getTask() async {
    try {
      print('Fetching tasks...');
      final tasks = await DBHelper.query();
      print('Tasks fetched: $tasks');
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void deleteTask({Task? task}) async {
    await DBHelper.delete(task!);
    getTask();
  }

  void markAsCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }

  addTask({Task? task}) async {
    await DBHelper.insert(task);
    getTask();
  }
}
