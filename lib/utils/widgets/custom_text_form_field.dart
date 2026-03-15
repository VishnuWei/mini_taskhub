import 'package:flutter/material.dart';
import '../form_data_notifier.dart';

class CustomTextFormField extends StatefulWidget {
  final Map<String, dynamic> fieldDef;
  final FormDataNotifier notifier;

  const CustomTextFormField(this.fieldDef, this.notifier, {super.key});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late final CustomTextFormFieldNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = CustomTextFormFieldNotifier(widget.fieldDef, widget.notifier);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final isWrapped =
            widget.fieldDef["labelText"] != null &&
            widget.fieldDef["labelText"].isNotEmpty;

        if (isWrapped) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.fieldDef["labelText"],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              buildTextField(context),
            ],
          );
        }

        return buildTextField(context);
      },
    );
  }

  Widget buildTextField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDescription = _notifier.isDescription;
    final prefixIcon = widget.fieldDef["prefixIcon"] as IconData?;
    final showToggle = widget.fieldDef["showToggle"] == true;
    final iconColor = _notifier.hasFocus
        ? colorScheme.primary
        : colorScheme.onSecondary;

    return TextFormField(
      controller: _notifier.controller,
      focusNode: _notifier.focusNode,
      obscureText: _notifier.obscureText,
      keyboardType: widget.fieldDef["textInputType"] ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: _notifier.updateValue,
      maxLines: isDescription ? null : 1,
      maxLength: isDescription ? 250 : null,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        letterSpacing: 0.2,
      ),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        hintText: widget.fieldDef["hintText"],
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSecondary,
        ),
        counterText: isDescription ? _notifier.counterText : '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        // Prefix icon
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(prefixIcon, size: 20, color: iconColor),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        suffixIcon: showToggle
            ? GestureDetector(
                onTap: _notifier.toggleObscure,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    _notifier.obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: colorScheme.onSecondary,
                  ),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        border: _border(colorScheme.outline),
        enabledBorder: _border(colorScheme.outline),
        focusedBorder: _border(colorScheme.primary, width: 1.5),
        errorBorder: _border(colorScheme.error),
        focusedErrorBorder: _border(colorScheme.error, width: 1.5),
        // labelText: widget.fieldDef["labelText"],
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSecondary,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
      ),
      validator: widget.fieldDef["validationRegEx"] != null
          ? (value) =>
                (widget.fieldDef["validationRegEx"]
                    as String? Function(String?))(value)
          : null,
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class CustomTextFormFieldNotifier extends ChangeNotifier {
  final Map<String, dynamic> fieldDef;
  final FormDataNotifier notifier;

  late final TextEditingController controller;
  late final FocusNode focusNode;

  String fieldName = '';
  String parentFieldName = '';
  bool isDescription = false;
  bool obscureText = false;
  bool hasFocus = false;
  String counterText = '';

  CustomTextFormFieldNotifier(this.fieldDef, this.notifier) {
    _init();
  }

  void _init() {
    fieldName = fieldDef["fieldName"] ?? '';
    parentFieldName = fieldDef["parentFieldName"] ?? '';
    isDescription = fieldDef["textInputType"] == TextInputType.multiline;
    obscureText = fieldDef["hideText"] == true;

    final initialValue = notifier.getOrSetDefault(fieldName, '');
    controller = TextEditingController(text: initialValue);

    focusNode = FocusNode()
      ..addListener(() {
        hasFocus = focusNode.hasFocus;
        notifyListeners();
      });

    if (isDescription) {
      controller.addListener(() {
        counterText = '${controller.text.length}/250';
        notifyListeners();
      });
    }
  }

  void updateValue(String value) {
    if (parentFieldName.isNotEmpty) {
      notifier.updateValue(fieldName, value, subName: parentFieldName);
    } else {
      notifier.updateValue(fieldName, value);
    }
  }

  void toggleObscure() {
    obscureText = !obscureText;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
