import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../../utils/core_constants.dart';

class TaskService extends ChangeNotifier {
  final SupabaseService supabaseService;

  TaskService(this.supabaseService);

  CommonStatus tasksStatus = CommonStatus.initial();
  CommonStatus taskMutationStatus = CommonStatus.initial();

  fetchTasks() async {
    tasksStatus = CommonStatus.loading();
    notifyListeners();

    try {
      final user = supabaseService.client.auth.currentUser;

      if (user == null) {
        tasksStatus = CommonStatus.error("User not logged in");
        notifyListeners();
        return;
      }

      final response = await supabaseService.client
          .from('tasks')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      tasksStatus = CommonStatus.success(response);

      notifyListeners();
    } catch (e) {
      tasksStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  getTask(String taskId) async {
    taskMutationStatus = CommonStatus.loading();
    notifyListeners();

    try {
      final response = await supabaseService.client
          .from('tasks')
          .select()
          .eq('id', taskId)
          .single();

      taskMutationStatus = CommonStatus.success(response);

      notifyListeners();
    } catch (e) {
      taskMutationStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  /// CREATE TASK
  createTask(String title) async {
    taskMutationStatus = CommonStatus.loading();
    notifyListeners();

    try {
      final user = supabaseService.client.auth.currentUser;

      if (user == null) {
        taskMutationStatus = CommonStatus.error("User not logged in");
        notifyListeners();
        return;
      }

      await supabaseService.client.from('tasks').insert({
        "title": title,
        "user_id": user.id,
        "completed": false,
      });

      taskMutationStatus = CommonStatus.success(true);

      await fetchTasks();
    } catch (e) {
      taskMutationStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  updateTask({
    required String taskId,
    required String title,
  }) async {
    taskMutationStatus = CommonStatus.loading();
    notifyListeners();

    try {
      await supabaseService.client
          .from('tasks')
          .update({"title": title})
          .eq('id', taskId);

      taskMutationStatus = CommonStatus.success(true);

      await fetchTasks();
    } catch (e) {
      taskMutationStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  toggleTask({
    required String taskId,
    required bool completed,
  }) async {
    taskMutationStatus = CommonStatus.loading();
    notifyListeners();

    try {
      await supabaseService.client
          .from('tasks')
          .update({"completed": !completed})
          .eq('id', taskId);

      taskMutationStatus = CommonStatus.success(true);

      await fetchTasks();
    } catch (e) {
      taskMutationStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  deleteTask(String taskId) async {
    taskMutationStatus = CommonStatus.loading();
    notifyListeners();

    try {
      await supabaseService.client.from('tasks').delete().eq('id', taskId);

      taskMutationStatus = CommonStatus.success(true);

      await fetchTasks();
    } catch (e) {
      taskMutationStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }
}
