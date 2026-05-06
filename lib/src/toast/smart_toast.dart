import 'package:flutter/material.dart';
import '../shared/ui_type.dart';
import '../shared/ui_position.dart';
import '../shared/ui_style.dart';
import 'toast_config.dart';

/// Show toast, snackbar, and banner notifications.
///
/// ## Quick use
/// ```dart
/// SmartToast.success(context, message: 'Saved!');
/// SmartToast.error(context, message: 'Failed!');
/// SmartToast.toast(context, message: 'Hello!');
/// ```
///
/// ## Full control
/// ```dart
/// SmartToast.show(context, config: ToastConfig(
///   message: 'Custom message',
///   backgroundColor: Colors.purple,
///   leadingIcon: Icon(Icons.star, color: Colors.white),
///   actionLabel: 'UNDO',
///   onActionPressed: () {},
/// ));
/// ```
class SmartToast {
  SmartToast._();

  static double _defaultElevationForStyle(SmartToastStyle style) {
    return style == SmartToastStyle.toast ? 4 : 0;
  }

  // ─── Shortcut methods ───────────────────────────────────────────────────────

  /// Show a success toast (green).
  static void success(BuildContext context,
      {required String message,
      String? title,
      SmartToastStyle style = SmartToastStyle.snackbar,
      SmartUIPosition position = SmartUIPosition.bottom,
      Duration duration = const Duration(seconds: 3),
      String? actionLabel,
      VoidCallback? onActionPressed,
      bool showCloseButton = false,
      Widget? leadingIcon,
      double borderRadius = 12}) {
    show(
      context,
      config: ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.success,
        style: style,
        position: position,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
        leadingIcon: leadingIcon,
        borderRadius: borderRadius,
        elevation: _defaultElevationForStyle(style),
      ),
    );
  }

  /// Show an error toast (red).
  static void error(BuildContext context,
      {required String message,
      String? title,
      SmartToastStyle style = SmartToastStyle.snackbar,
      SmartUIPosition position = SmartUIPosition.bottom,
      Duration duration = const Duration(seconds: 3),
      String? actionLabel,
      VoidCallback? onActionPressed,
      bool showCloseButton = true,
      Widget? leadingIcon,
      double borderRadius = 12}) {
    show(
      context,
      config: ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.error,
        style: style,
        position: position,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
        leadingIcon: leadingIcon,
        borderRadius: borderRadius,
        elevation: _defaultElevationForStyle(style),
      ),
    );
  }

  /// Show an info toast (blue).
  static void info(BuildContext context,
      {required String message,
      String? title,
      SmartToastStyle style = SmartToastStyle.snackbar,
      SmartUIPosition position = SmartUIPosition.bottom,
      Duration duration = const Duration(seconds: 3),
      String? actionLabel,
      VoidCallback? onActionPressed,
      bool showCloseButton = false,
      Widget? leadingIcon,
      double borderRadius = 12}) {
    show(
      context,
      config: ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.info,
        style: style,
        position: position,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
        leadingIcon: leadingIcon,
        borderRadius: borderRadius,
        elevation: _defaultElevationForStyle(style),
      ),
    );
  }

  /// Show a warning toast (orange).
  static void warning(BuildContext context,
      {required String message,
      String? title,
      SmartToastStyle style = SmartToastStyle.snackbar,
      SmartUIPosition position = SmartUIPosition.bottom,
      Duration duration = const Duration(seconds: 3),
      String? actionLabel,
      VoidCallback? onActionPressed,
      bool showCloseButton = false,
      Widget? leadingIcon,
      double borderRadius = 12}) {
    show(
      context,
      config: ToastConfig(
        message: message,
        title: title,
        type: SmartUIType.warning,
        style: style,
        position: position,
        duration: duration,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseButton: showCloseButton,
        leadingIcon: leadingIcon,
        borderRadius: borderRadius,
        elevation: _defaultElevationForStyle(style),
      ),
    );
  }

  /// Show a plain Android-style toast.
  static void toast(BuildContext context,
      {required String message,
      SmartUIPosition position = SmartUIPosition.bottom,
      Duration duration = const Duration(seconds: 2),
      double borderRadius = 24}) {
    show(
      context,
      config: ToastConfig(
        message: message,
        type: SmartUIType.plain,
        style: SmartToastStyle.toast,
        position: position,
        duration: duration,
        borderRadius: borderRadius,
      ),
    );
  }

  // ─── Main show method ───────────────────────────────────────────────────────

  /// Show any toast using a [ToastConfig].
  static void show(BuildContext context, {required ToastConfig config}) {
    if (!context.mounted) return;

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      throw FlutterError(
        'SmartToast.show() could not find an Overlay.\n'
        'Make sure you call it with a BuildContext below a MaterialApp/CupertinoApp '
        '(or an Overlay widget).',
      );
    }

    late OverlayEntry entry;
    var dismissed = false;

    void dismiss() {
      if (dismissed) return;
      dismissed = true;
      try {
        entry.remove();
      } catch (_) {}
      config.onDismiss?.call();
    }

    entry = OverlayEntry(
      builder: (ctx) => _ToastOverlay(
        config: config,
        onDismiss: dismiss,
        onAction: () {
          config.onActionPressed?.call();
          dismiss();
        },
      ),
    );

    overlay.insert(entry);

    Future.delayed(
      config.duration + config.animationDuration,
      dismiss,
    );
  }
}

// ─── Internal overlay ──────────────────────────────────────────────────────────

class _ToastOverlay extends StatefulWidget {
  final ToastConfig config;
  final VoidCallback onDismiss;
  final VoidCallback onAction;

  const _ToastOverlay({
    required this.config,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: widget.config.animationDuration);
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    final isTop = widget.config.style == SmartToastStyle.bannerTop ||
        widget.config.position == SmartUIPosition.top;

    _slide = Tween<Offset>(
      begin: Offset(0, isTop ? -0.4 : 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.forward();
    Future.delayed(widget.config.duration, () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
 
  Color get _bgColor {
    if (widget.config.backgroundColor != null) {
      return widget.config.backgroundColor!;
    }
    switch (widget.config.type) {
      case SmartUIType.success:
        return const Color(0xFF2E7D32);
      case SmartUIType.error:
        return const Color(0xFFC62828);
      case SmartUIType.info:
        return const Color(0xFF1565C0);
      case SmartUIType.warning:
        return const Color(0xFFE65100);
      case SmartUIType.plain:
        return const Color(0xFF323232);
    }
  }

  IconData get _defaultIcon {
    switch (widget.config.type) {
      case SmartUIType.success:
        return Icons.check_circle_outline_rounded;
      case SmartUIType.error:
        return Icons.error_outline_rounded;
      case SmartUIType.info:
        return Icons.info_outline_rounded;
      case SmartUIType.warning:
        return Icons.warning_amber_rounded;
      case SmartUIType.plain:
        return Icons.notifications_none_rounded;
    }
  }

  AlignmentGeometry get _alignment {
    switch (widget.config.style) {
      case SmartToastStyle.bannerTop:
        return Alignment.topCenter;
      case SmartToastStyle.bannerBottom:
      case SmartToastStyle.snackbar:
        return Alignment.bottomCenter;
      case SmartToastStyle.toast:
        switch (widget.config.position) {
          case SmartUIPosition.top:
            return Alignment.topCenter;
          case SmartUIPosition.center:
            return Alignment.center;
          case SmartUIPosition.bottom:
            return Alignment.bottomCenter;
        }
    }
  }

  EdgeInsets get _margin {
    // Backwards-compatible default margin.
    final isFull = widget.config.style == SmartToastStyle.bannerTop ||
        widget.config.style == SmartToastStyle.bannerBottom;
    if (isFull) return EdgeInsets.zero;

    const side = 16.0;
    const minTopBottom = 60.0;

    // Use safe areas only when they exceed the default spacing.
    final mq = MediaQuery.maybeOf(context);
    final safeTop = mq?.padding.top ?? 0.0;
    final safeBottom = mq?.padding.bottom ?? 0.0;
    final resolvedTop = (safeTop + side) < minTopBottom
        ? minTopBottom
        : (safeTop + side);
    final resolvedBottom = (safeBottom + side) < minTopBottom
        ? minTopBottom
        : (safeBottom + side);

    switch (widget.config.position) {
      case SmartUIPosition.top:
        return EdgeInsets.only(top: resolvedTop, left: side, right: side);
      case SmartUIPosition.center:
        return const EdgeInsets.symmetric(horizontal: side);
      case SmartUIPosition.bottom:
        return EdgeInsets.only(
            bottom: resolvedBottom, left: side, right: side);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final fg = c.textColor ?? Colors.white;
    final isFull = c.style == SmartToastStyle.bannerTop ||
        c.style == SmartToastStyle.bannerBottom ||
        c.style == SmartToastStyle.snackbar;

    final resolvedBorderRadius =
        (c.style == SmartToastStyle.bannerTop ||
                c.style == SmartToastStyle.bannerBottom)
            ? 0.0
            : c.borderRadius;

    return Positioned.fill(
      child: Align(
        alignment: _alignment,
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _opacity,
            child: Container(
              margin: c.margin ?? _margin,
              width: isFull ? double.infinity : null,
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(resolvedBorderRadius),
                boxShadow: c.elevation > 0
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).round()),
                          blurRadius: c.elevation * 2,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              padding: c.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (c.type != SmartUIType.plain || c.leadingIcon != null) ...[
                    c.leadingIcon ??
                        Icon(_defaultIcon, color: c.iconColor ?? fg, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (c.title != null)
                          Text(c.title!,
                              style: c.titleStyle ??
                                  TextStyle(
                                      color: fg,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                        if (c.title != null) const SizedBox(height: 2),
                        Text(c.message,
                            style: c.messageStyle ??
                                TextStyle(
                              color:
                                fg.withAlpha(c.title != null ? 230 : 255),
                                    fontSize: 14)),
                      ],
                    ),
                  ),
                  if (c.actionLabel != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: widget.onAction,
                      style: TextButton.styleFrom(
                        foregroundColor: fg,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(c.actionLabel!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ],
                  if (c.showCloseButton) ...[
                    const SizedBox(width: 4), 
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: Icon(Icons.close_rounded, color: fg, size: 18),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}