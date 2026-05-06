import 'package:flutter/material.dart';
import '../shared/ui_type.dart';
import '../shared/ui_style.dart';

/// A button definition for [SmartDialog].
class DialogButton {
  /// Button label text.
  final String label;

  /// Called when this button is tapped. Dialog closes automatically.
  final VoidCallback? onPressed;

  /// Override button text color.
  final Color? textColor;

  /// If true, button has filled background.
  final bool filled;

  /// Override button background color (only when [filled] is true).
  final Color? fillColor;

  const DialogButton({
    required this.label,
    this.onPressed,
    this.textColor,
    this.filled = false,
    this.fillColor,
  });

  /// Quick cancel button.
  factory DialogButton.cancel({String label = 'Cancel', VoidCallback? onPressed}) =>
      DialogButton(label: label, onPressed: onPressed);

  /// Quick confirm button (filled blue).
  factory DialogButton.confirm({
    String label = 'Confirm',
    VoidCallback? onPressed,
    Color fillColor = const Color(0xFF1565C0),
  }) =>
      DialogButton(
          label: label,
          onPressed: onPressed,
          filled: true,
          fillColor: fillColor);

  /// Quick destructive button (filled red).
  factory DialogButton.destructive(
          {String label = 'Delete', VoidCallback? onPressed}) =>
      DialogButton(
          label: label,
          onPressed: onPressed,
          filled: true,
          fillColor: const Color(0xFFC62828));
}

/// Configuration for [SmartDialog].
class DialogConfig {
  /// Dialog title text.
  final String? title;

  /// Dialog message/content text.
  final String? message;

  /// Custom content widget — replaces [message] if provided.
  final Widget? content;

  /// Visual style.
  final SmartDialogStyle style;

  /// Color theme (used for header icon background in [SmartDialogStyle.withHeader]).
  final SmartUIType type;

  /// Icon shown in the floating header circle (for [SmartDialogStyle.withHeader]).
  final IconData? headerIcon;

  /// Custom widget shown as header (overrides [headerIcon]).
  final Widget? headerWidget;

  /// Header circle background color override.
  final Color? headerColor;

  /// List of action buttons.
  final List<DialogButton> buttons;

  /// Dialog background color.
  final Color? backgroundColor;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Message text style.
  final TextStyle? messageStyle;

  /// Corner radius.
  final double borderRadius;

  /// Whether tapping outside dismisses the dialog.
  final bool barrierDismissible;

  /// Called when dialog is dismissed (any way).
  final VoidCallback? onDismiss;

  const DialogConfig({
    this.title,
    this.message,
    this.content,
    this.style = SmartDialogStyle.standard,
    this.type = SmartUIType.info,
    this.headerIcon,
    this.headerWidget,
    this.headerColor,
    this.buttons = const [],
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
    this.borderRadius = 16,
    this.barrierDismissible = true,
    this.onDismiss,
  });

  /// Quick confirm dialog.
  factory DialogConfig.confirm({
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color confirmColor = const Color(0xFF1565C0),
  }) =>
      DialogConfig(
        title: title,
        message: message,
        buttons: [
          DialogButton.cancel(label: cancelLabel, onPressed: onCancel),
          DialogButton.confirm(
              label: confirmLabel,
              onPressed: onConfirm,
              fillColor: confirmColor),
        ],
      );

  /// Quick alert dialog (one button).
  factory DialogConfig.alert({
    required String title,
    required String message,
    String buttonLabel = 'Okay',
    VoidCallback? onPressed,
    SmartDialogStyle style = SmartDialogStyle.withHeader,
    SmartUIType type = SmartUIType.info,
    IconData? headerIcon,
  }) =>
      DialogConfig(
        title: title,
        message: message,
        style: style,
        type: type,
        headerIcon: headerIcon,
        buttons: [DialogButton(label: buttonLabel, onPressed: onPressed)],
      );

  /// Quick delete/destructive confirmation.
  factory DialogConfig.destructive({
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String deleteLabel = 'Delete',
    VoidCallback? onDelete,
  }) =>
      DialogConfig(
        title: title,
        message: message,
        type: SmartUIType.error,
        style: SmartDialogStyle.withHeader,
        headerIcon: Icons.delete_outline_rounded,
        buttons: [
          DialogButton.cancel(label: cancelLabel),
          DialogButton.destructive(label: deleteLabel, onPressed: onDelete),
        ],
      );
}