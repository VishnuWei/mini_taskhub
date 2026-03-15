import 'package:flutter/material.dart';
import '../../utils/widgets/widget_factory.dart';

class TaskUiDef {
  static Map<String, dynamic> get taskName => {
    "fieldName": "taskName",
    "labelText": "Task Name",
    "hintText": "Buy groceries",
    "prefixIcon": Icons.task_alt_rounded,
    "textInputType": TextInputType.text,
    "widgetType": WidgetType.textBox,
  };
}
