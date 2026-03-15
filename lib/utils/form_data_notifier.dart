import 'package:flutter/material.dart';

class FormDataNotifier extends ChangeNotifier {
  FormDataNotifier();

  Map<String, dynamic> formData = {};
  Map<String, dynamic> serverData = {};

  String? changedParam;

  initializeToValue(String fieldName) {
    return formData[fieldName] ?? serverData[fieldName];
  }

  getOrSetDefault(key, defaultValue) {
    if (!formData.containsKey(key) || formData[key] == null) {
      if (!serverData.containsKey(key) || serverData[key] == null) {
        serverData[key] = defaultValue;
      }
      formData[key] = serverData[key];
    }
    return formData[key];
  }

  initializeFormData(Map<String, dynamic> formData,
      {Map<String, dynamic>? serverData}) {
    this.formData = formData;
    this.serverData = serverData ?? formData;
    notifyListeners();
  }

  updated({required String fieldName}) {
    changedParam = fieldName;
    debugPrint('changedParam:$changedParam');
    notifyListeners();
  }

  updateValue(String fieldName, dynamic value, {String? subName}) {
    if (subName != null) {
      formData[subName]?[fieldName] = value;
      debugPrint('formData[$subName][$fieldName]:$value');
    } else {
      formData[fieldName] = value;
      debugPrint('formData[$fieldName]:$value');
    }
    notifyListeners();
  }

  removeValueAtKey(String key) {
    formData.remove(key);
    debugPrint('formData[$key]: ${formData[key]}');
    notifyListeners();
  }

  updateFormData(Map<String, dynamic> newData) {
    formData.addAll(newData);
    debugPrint('Form data updated with multiple values: $newData');
    changedParam = 'bulk_update';
    notifyListeners();
  }
}
