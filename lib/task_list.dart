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
  List<TaskItem> _tasks = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('f7c7p33kzg.execute-api.ap-south-1.amazonaws.com','/Develop/task-management-serverless/all');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final List<dynamic> responseData = json.decode(response.body);

      final List<TaskItem> loadedItems = [];

      for(final item in responseData) {

        final priority = priorities.entries.firstWhere((priorityItem) => priorityItem.value.title == item['priority']).value;

        final status = statuses.entries.firstWhere((statusItem) => statusItem.value.title == item['status']).value;

        loadedItems.add(
          TaskItem(
            id: item['id'], 
            title: item['title'], 
            description: item['description'], 
            priority: priority, 
            status: status, 
            enddate: item['enddate'], 
            teamsize: item['teamsize']
          )
        );
        
        setState(() {
          _tasks = loadedItems;
          _isLoading = false;
        });

      }
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
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

    final url = Uri.https('f7c7p33kzg.execute-api.ap-south-1.amazonaws.com','/Develop/task-management-serverless',{'taskid': item.id});

    print(url);

    final response = await http.delete(url);

    print(response.body);

    if (response.statusCode >= 400) {
      setState(() {
        _tasks.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet.'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_tasks.isNotEmpty) {
      content = ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_tasks[index]);
          },
          key: ValueKey(_tasks[index].id),
          child: ListTile(
            title: Text(_tasks[index].title),
            leading: Container(
              width: 24,
              height: 24,
              color: _tasks[index].priority.color,
            ),
            trailing: Text(_tasks[index].teamsize.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

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
        body: content);
  }
}
