import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todo/data/models/task.dart';

const _boxName = 'tasks';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  Box<Task>? _taskBox;

  // Инициализация Hive box (вызывается один раз при старте)
  FutureOr<Box<Task>> get _getBox async {
    _taskBox ??= await Hive.openBox<Task>(_boxName);
    return _taskBox!;
  }

  Future<void> init() async {
    try {
      final box = await _getBox;
      final tasks = box.values.toList();
      state = tasks;
    } catch (e) {
      state = [];
      debugPrint('Ошибка инициализации Hive: $e');
    }
  }

  Future<void> addTask(String title) async {
    try {
      final task = Task.create(title);
      final box = await _getBox;
      await box.add(task);
      state = [...state, task];
    } catch (e) {
      debugPrint('Ошибка добавления задачи: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final box = await _getBox;
      final taskIndex = state.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      final task = state[taskIndex];
      final hiveKey = box.keyAt(box.values.toList().indexOf(task));
      await box.delete(hiveKey);

      state = List<Task>.from(state)..removeAt(taskIndex);
    } catch (e) {
      debugPrint('Ошибка удаления задачи: $e');
    }
  }

  Future<void> toggleTask(String taskId) async {
    try {
      final box = await _getBox;
      final taskIndex = state.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) return;

      final updatedTask = state[taskIndex].toggleStatus();

      final hiveKey = box.keyAt(box.values.toList().indexOf(state[taskIndex]));
      await box.put(hiveKey, updatedTask);

      state = List<Task>.from(state)..[taskIndex] = updatedTask;
    } catch (e) {
      debugPrint('Ошибка смены статуса: $e');
    }
  }
}

// Провайдер для доступа к TaskNotifier
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
