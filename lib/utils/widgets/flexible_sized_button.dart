import 'package:flutter/material.dart';

class FlexibleSizedButton extends StatelessWidget {
  const FlexibleSizedButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.padding,
    this.isOutlined = false,
    this.borderRadius = 10,
    this.leading,
    this.spacing = 8,
  });

  final VoidCallback onPressed;
  final String buttonName;

  final double? width;
  final double? height;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  final EdgeInsetsGeometry? padding;

  final bool isOutlined;
  final double borderRadius;

  final Widget? leading;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bg = backgroundColor ?? colorScheme.primary;
    final border = borderColor ?? colorScheme.primary;
    final txt = textColor ?? colorScheme.onPrimary;

    final buttonChild = SizedBox(
      width: width,
      height: height ?? 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: spacing),
          ],
          Text(
            buttonName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: txt,
            ),
          ),
        ],
      ),
    );

    final style = ButtonStyle(
      padding: WidgetStateProperty.all(
        padding ?? const EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: border),
        ),
      ),
    );

    if (isOutlined) {
      return OutlinedButton(
        style: style.copyWith(
          side: WidgetStateProperty.all(BorderSide(color: border)),
        ),
        onPressed: onPressed,
        child: buttonChild,
      );
    }

    return ElevatedButton(
      style: style.copyWith(
        backgroundColor: WidgetStateProperty.all(bg),
        foregroundColor: WidgetStateProperty.all(txt),
      ),
      onPressed: onPressed,
      child: buttonChild,
    );
  }
}