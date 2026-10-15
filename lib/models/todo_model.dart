
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoTask {
  final String id;
  final String name;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;

  TodoTask({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  TodoTask copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
  }) {
    return TodoTask(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }

  factory TodoTask.fromJson(Map<String, dynamic> json) {
    return TodoTask(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
    );
  }
}

class TodoStore {
  static const String _storageKey = 'saved_todo_tasks';

  static final ValueNotifier<List<TodoTask>> tasks =
      ValueNotifier<List<TodoTask>>([]);

  static Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      tasks.value = [];
      return;
    }

    try {
      final List<dynamic> decodedData = jsonDecode(savedData) as List;

      tasks.value = decodedData.map((item) {
        return TodoTask.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    } catch (error) {
      debugPrint('Error loading tasks: $error');
    }
  }

  static Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = jsonEncode(
      tasks.value.map((task) => task.toJson()).toList(),
    );

    await prefs.setString(_storageKey, savedData);
  }

  static Future<void> addTask(TodoTask task) async {
    tasks.value = [...tasks.value, task];
    await _saveTasks();
  }

  static Future<void> updateTask(
    int index,
    TodoTask task,
  ) async {
    final updatedTasks = [...tasks.value];

    if (index >= 0 && index < updatedTasks.length) {
      updatedTasks[index] = task;
      tasks.value = updatedTasks;
      await _saveTasks();
    }
  }

  static Future<void> deleteTask(int index) async {
    final updatedTasks = [...tasks.value];

    if (index >= 0 && index < updatedTasks.length) {
      updatedTasks.removeAt(index);
      tasks.value = updatedTasks;
      await _saveTasks();
    }
  }
}
