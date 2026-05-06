import 'package:flutter/material.dart';
import '../shared/ui_type.dart';
import '../shared/ui_position.dart';
import '../shared/ui_style.dart';

/// Configuration for [SmartToast].
///
/// Pass this to [SmartToast.show()] for full control.
class ToastConfig {
  /// The main message text (required).
  final String message;

  /// Optional bold title shown above message.
  final String? title;

  /// Color theme.
  final SmartUIType type;

  /// Shape/position style.
  final SmartToastStyle style;

  /// Position on screen (for [SmartToastStyle.toast] only).
  final SmartUIPosition position;

  /// How long to show before auto-dismiss.
  final Duration duration;

  /// Override background color.
  final Color? backgroundColor;

  /// Override text color.
  final Color? textColor;

  /// Override icon color.
  final Color? iconColor;

  /// Custom leading widget (icon, image, etc).
  final Widget? leadingIcon;

  /// Corner radius.
  final double borderRadius;

  /// Shadow elevation.
  final double elevation;

  /// Custom inner padding.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the toast container.
  ///
  /// If null, a sensible default margin is used.
  final EdgeInsetsGeometry? margin;

  /// Custom title text style.
  final TextStyle? titleStyle;

  /// Custom message text style.
  final TextStyle? messageStyle;

  /// Action button label (e.g. 'UNDO', 'RETRY').
  final String? actionLabel;

  /// Called when action button is tapped.
  final VoidCallback? onActionPressed;

  /// Show × close button.
  final bool showCloseButton;

  /// Called when dismissed.
  final VoidCallback? onDismiss;

  /// Slide/fade animation speed.
  final Duration animationDuration;

  const ToastConfig({
    required this.message,
    this.title,
    this.type = SmartUIType.plain,
    this.style = SmartToastStyle.toast,
    this.position = SmartUIPosition.bottom,
    this.duration = const Duration(seconds: 3),
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.leadingIcon,
    this.borderRadius = 12,
    this.elevation = 4,
    this.padding,
    this.margin,
    this.titleStyle,
    this.messageStyle,
    this.actionLabel,
    this.onActionPressed,
    this.showCloseButton = false,
    this.onDismiss,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  /// Quickly create a success config.
  factory ToastConfig.success({
    required String message,
    String? title,
    SmartToastStyle style = SmartToastStyle.snackbar,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseButton = false,
    double? elevation,
  }) =>
      ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.success,
        style: style,
        elevation: elevation ?? (style == SmartToastStyle.toast ? 4 : 0),
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
      );

  /// Quickly create an error config.
  factory ToastConfig.error({
    required String message,
    String? title,
    SmartToastStyle style = SmartToastStyle.snackbar,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool showCloseButton = true,
    double? elevation,
  }) =>
      ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.error,
        style: style,
        elevation: elevation ?? (style == SmartToastStyle.toast ? 4 : 0),
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
      );

  /// Quickly create an info config.
  factory ToastConfig.info({
    required String message,
    String? title,
    SmartToastStyle style = SmartToastStyle.snackbar,
    double? elevation,
  }) =>
      ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.info,
        style: style,
        elevation: elevation ?? (style == SmartToastStyle.toast ? 4 : 0),
      );

  /// Quickly create a warning config.
  factory ToastConfig.warning({
    required String message,
    String? title,
    SmartToastStyle style = SmartToastStyle.snackbar,
    double? elevation,
  }) =>
      ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.warning,
        style: style,
        elevation: elevation ?? (style == SmartToastStyle.toast ? 4 : 0),
      );
}  