import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tasks_management_application/data/priorities.dart';
import 'package:tasks_management_application/data/statuses.dart';
// import 'package:tasks_management_application/data/dummydata.dart';
import 'package:tasks_management_application/models/task.dart';
import 'package:tasks_management_application/task_form.dart';
import 'package:http/http.dart' as http;

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final List<TaskItem> _tasks = [];
  late Future<List<TaskItem>> _loadedItems;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

  Future<List<TaskItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-task-management-74d34-default-rtdb.asia-southeast1.firebasedatabase.app',
        'task-management.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fectch tasks. Please try again later.');
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> listdata = json.decode(response.body);

    final List<TaskItem> loadedItems = [];

    for (final item in listdata.entries) {
      final priority = priorities.entries
          .firstWhere((priorityItem) =>
              priorityItem.value.title == item.value['priority'])
          .value;
      final status = statuses.entries
          .firstWhere(
              (statusItem) => statusItem.value.title == item.value['status'])
          .value;

      loadedItems.add(
        TaskItem(
          id: item.key,
          title: item.value['title'],
          description: item.value['description'],
          priority: priority,
          status: status,
          enddate: item.value['enddate'],
          teamsize: item.value['teamsize'],
        ),
      );
    }
    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<TaskItem>(
      MaterialPageRoute(
        builder: (ctx) => const TaskForm(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _tasks.add(newItem);
    });
  }

  void _removeItem(TaskItem item) async {
    final index = _tasks.indexOf(item);

    setState(() {
      _tasks.remove(item);
    });

    final url = Uri.https(
        'flutter-task-management-74d34-default-rtdb.asia-southeast1.firebasedatabase.app',
        'task-management/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _tasks.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No items added yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              key: ValueKey(snapshot.data![index].id),
              child: ListTile(
                title: Text(snapshot.data![index].title),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: snapshot.data![index].priority.color,
                ),
                trailing: Text(snapshot.data![index].teamsize.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
