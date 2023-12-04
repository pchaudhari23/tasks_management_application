import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasks_management_application/data/priorities.dart';
import 'package:tasks_management_application/data/statuses.dart';
import 'package:tasks_management_application/models/priority.dart';
import 'package:tasks_management_application/models/status.dart';
// import 'package:tasks_management_application/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:tasks_management_application/models/task.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formkey = GlobalKey<FormState>();

  var _title = '';
  var _description = '';
  var _enddate = '';
  var _teamsize = 1;
  var _selectedPriority = priorities[Priorities.medium]!;
  var _selectedStatus = statuses[Statuses.backlog]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https('f7c7p33kzg.execute-api.ap-south-1.amazonaws.com','/Develop/task-management-serverless');

      final response = await http.post(
        url,
        // headers: {
        //   'Content-Type': 'application/json',
        // },
        body: json.encode(
          {
            'task_title': _title,
            'task_description': _description,
            'task_priority': _selectedPriority.title,
            'task_status': _selectedStatus.title,
            'task_enddate': _enddate,
            'task_teamsize': _teamsize
          },
        ),
      );

      // final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(
        TaskItem(
          id: '',
          title: _title,
          description: _description,
          priority: _selectedPriority,
          status: _selectedStatus,
          enddate: _enddate,
          teamsize: _teamsize,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                  hintText: 'Enter the task title',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                maxLength: 200,
                maxLines: 4,
                decoration: const InputDecoration(
                  label: Text('Description'),
                  hintText: 'Enter the task description',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 200) {
                    return 'Must be between 1 and 200 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text('Priority'),
                      ),
                      value: _selectedPriority,
                      items: [
                        for (final priority in priorities.entries)
                          DropdownMenuItem(
                            value: priority.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: priority.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(priority.value.title)
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          label: Text('Status'),
                        ),
                        value: _selectedStatus,
                        items: [
                          for (final status in statuses.entries)
                            DropdownMenuItem(
                              value: status.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: status.value.color,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(status.value.title)
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        }),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('End date'),
                        hintText: 'Enter the end date',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Must be between 1 and 50 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enddate = value!;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Team size'),
                        hintText: 'Enter the team size',
                      ),
                      initialValue: _teamsize.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _teamsize = int.parse(value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formkey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add task'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
