import 'package:flutter/material.dart';
import '../form_data_notifier.dart';
import 'custom_privacy_policy_widget.dart';
import 'custom_text_form_field.dart';

class WidgetFactory {
  static Widget buildWidgetTree(
      BuildContext context,
      Map<String, dynamic> fieldDef,
      FormDataNotifier formDataNotifier) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldDef['title'] ?? '',
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSecondary),
        ),
        const SizedBox(height: 8),
        WidgetFactory.build(
          context,
          fieldDef,
          formDataNotifier,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  static List<Widget> buildFromList(
    BuildContext context,
    List<Map<String, dynamic>> fieldDefs,
    FormDataNotifier formDataNotifier,
  ) {
    List<Widget> list = <Widget>[];
    for (var fieldDef in fieldDefs) {
      final fieldName = fieldDef['fieldName'] ?? UniqueKey().toString();
      Widget widget = Padding(
        padding: EdgeInsets.all(8.0),
        child: KeyedSubtree(
          key: ValueKey(fieldName),
          child: build(
            context,
            fieldDef,
            formDataNotifier,
          ),
        ),
      );

      list.add(widget);
    }
    return list;
  }

  static List<Widget> buildFromMap(
      BuildContext context,
      Map<String, Map<String, dynamic>> fieldDefs,
      FormDataNotifier formDataNotifier) {
    List<Map<String, dynamic>> fields = <Map<String, dynamic>>[];
    for (var fieldDef in fieldDefs.entries) {
      fields.add(fieldDef.value);
    }
    List<Widget> widgets =
        buildFromList(context, fields, formDataNotifier);
    return widgets;
  }

  static Widget build(
    BuildContext context,
    Map<String, dynamic> fieldDef,
    FormDataNotifier formDataNotifier,
  ) {
    final fieldName = fieldDef['fieldName'] ?? UniqueKey().toString();

    Widget child;

    if (fieldDef["widgetType"] == WidgetType.textBox) {
      child = CustomTextFormField(fieldDef, formDataNotifier);
    } else if (fieldDef["widgetType"] ==
        WidgetType.customPrivacyPolicyWidget) {
      child = CustomPrivacyPolicyWidget(formDataNotifier, fieldDef);
    } else {
      child = CustomTextFormField(fieldDef, formDataNotifier);
    }

    return KeyedSubtree(
      key: ValueKey(fieldName),
      child: child,
    );
  }
}

enum WidgetType {
  textBox,
  customPrivacyPolicyWidget
}
