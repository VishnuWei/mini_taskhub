import 'package:flutter/material.dart';
import 'package:mini_taskhub/main.dart';
import 'package:mini_taskhub/pages/app_routes.dart';
import 'package:mini_taskhub/utils/response_handler.dart';
import 'package:provider/provider.dart';
import '../../utils/form_data_notifier.dart';
import '../../utils/widgets/flexible_sized_button.dart';
import '../../utils/widgets/widget_factory.dart';
import 'task_service.dart';
import 'task_ui_def.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentContext!.read<TaskService>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskService = context.watch<TaskService>();

    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Tasks", style: textTheme.titleLarge),
          centerTitle: true,
          actions: [
            IconButton(
              icon: CircleAvatar(
                child: Icon(Icons.person, color: colorScheme.onPrimary),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.myProfileScreen);
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: _showAddTaskSheet,
          child: Icon(Icons.add, color: colorScheme.onPrimary),
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: ResponseHandler.getResponseWidget(
            context,
            taskService.tasksStatus,
            _buildTaskList(taskService),
            initialWidget: _buildTaskList(taskService),
            errorWidget: _buildTaskList(taskService),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskService service) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final tasks = service.tasksStatus.successData ?? [];

    if (tasks.isEmpty) {
      return Center(child: Text("No tasks yet", style: textTheme.bodyLarge));
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => SizedBox(height: size.height * 0.015),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Dismissible(
          key: ValueKey(task["id"]),
          direction: DismissDirection.endToStart,

          onDismissed: (_) {
            context.read<TaskService>().removeTaskLocally(task["id"]);
            context.read<TaskService>().deleteTask(task["id"]);
          },

          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: size.width * 0.05),
            decoration: BoxDecoration(
              color: colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.delete, color: colorScheme.onError),
          ),

          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.015,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                Checkbox(
                  value: task["completed"],
                  activeColor: colorScheme.primary,
                  onChanged: (_) {
                    context.read<TaskService>().toggleTask(
                      taskId: task["id"],
                      completed: task["completed"],
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    task["title"],
                    style: textTheme.bodyLarge?.copyWith(
                      decoration: task["completed"]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: colorScheme.primary),
                  onPressed: () {
                    _showEditTaskSheet(task);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddTaskSheet() {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

    final formNotifier = FormDataNotifier();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Task", style: textTheme.titleLarge),

              SizedBox(height: size.height * 0.02),

              ...WidgetFactory.buildFromList(context, [
                TaskUiDef.taskName,
              ], formNotifier),

              SizedBox(height: size.height * 0.02),

              ResponseHandler.getResponseWidget(
                context,
                context.read<TaskService>().taskMutationStatus,
                buildCreateButton(formNotifier),
                initialWidget: buildCreateButton(formNotifier),
                errorWidget: buildCreateButton(formNotifier),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCreateButton(FormDataNotifier formNotifier) {
    return FlexibleSizedButton(
      borderRadius: 12,
      buttonName: "Add Task",
      onPressed: () {
        final title = formNotifier.formData["taskName"];

        if (title == null || title.isEmpty) return;

        context.read<TaskService>().createTask(title);

        Navigator.pop(context);
      },
    );
  }

  Widget buildEditButton(FormDataNotifier formNotifier, Map task) {
    return FlexibleSizedButton(
      borderRadius: 12,
      buttonName: "Update Task",
      onPressed: () {
        final title = formNotifier.formData["taskName"];

        context.read<TaskService>().updateTask(
          taskId: task["id"],
          title: title,
        );

        Navigator.pop(context);
      },
    );
  }

  void _showEditTaskSheet(Map task) {
    final formNotifier = FormDataNotifier();

    formNotifier.updateValue("taskName", task["title"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...WidgetFactory.buildFromList(context, [
                TaskUiDef.taskName,
              ], formNotifier),

              const SizedBox(height: 20),

              ResponseHandler.getResponseWidget(
                context,
                context.read<TaskService>().taskMutationStatus,
                buildEditButton(formNotifier, task),
                initialWidget: buildEditButton(formNotifier, task),
                errorWidget: buildEditButton(formNotifier, task),
              ),
            ],
          ),
        );
      },
    );
  }
}
