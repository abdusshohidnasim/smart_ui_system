import 'package:flutter/material.dart';
import '../shared/ui_type.dart';
import '../shared/ui_style.dart';
import 'dilog_config.dart';

/// Show beautiful, fully customizable dialogs.
///
/// ## Quick use
/// ```dart
/// SmartDialog.confirm(context,
///   title: 'Privacy Info',
///   message: 'This may contain sensitive data.',
///   onConfirm: () => doSomething(),
/// );
///
/// SmartDialog.alert(context,
///   title: 'Success',
///   message: 'Your data was saved.',
///   type: SmartUIType.success,
/// );
/// ```
///
/// ## Full control
/// ```dart
/// SmartDialog.show(context, config: DialogConfig(
///   title: 'Custom Dialog',
///   content: MyCustomWidget(),
///   buttons: [
///     DialogButton.cancel(),
///     DialogButton.confirm(onPressed: () {}),
///   ],
/// ));
/// ```
class SmartDialog {
  SmartDialog._();

  // ─── Shortcuts ──────────────────────────────────────────────────────────────

  /// Standard confirm/cancel dialog.
  static Future<void> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color confirmColor = const Color(0xFF1565C0),
  }) {
    return show(
      context,
      config: DialogConfig.confirm(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
      ),
    );
  }

  /// Alert dialog with icon header (success/error/info/warning).
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'Okay',
    VoidCallback? onPressed,
    SmartUIType type = SmartUIType.info,
    IconData? headerIcon,
  }) {
    return show(
      context,
      config: DialogConfig.alert(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        onPressed: onPressed,
        type: type,
        headerIcon: headerIcon,
      ),
    );
  }

  /// Delete/destructive confirmation dialog (red).
  static Future<void> destructive(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String deleteLabel = 'Delete',
    VoidCallback? onDelete,
  }) {
    return show(
      context,
      config: DialogConfig.destructive(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        deleteLabel: deleteLabel,
        onDelete: onDelete,
      ),
    );
  }

  // ─── Main show method ───────────────────────────────────────────────────────

  /// Show any dialog using a [DialogConfig].
  static Future<void> show(
    BuildContext context, {
    required DialogConfig config,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (ctx) => _SmartDialogWidget(config: config),
    ).then((_) => config.onDismiss?.call());
  }
}

// ─── Internal dialog widget ────────────────────────────────────────────────────

class _SmartDialogWidget extends StatelessWidget {
  final DialogConfig config;

  const _SmartDialogWidget({required this.config});

  Color get _typeColor {
    if (config.headerColor != null) return config.headerColor!;
    switch (config.type) {
      case SmartUIType.success:
        return const Color(0xFF2E7D32);
      case SmartUIType.error:
        return const Color(0xFFC62828);
      case SmartUIType.info:
        return const Color(0xFF1565C0);
      case SmartUIType.warning:
        return const Color(0xFFE65100);
      case SmartUIType.plain:
        return const Color(0xFF424242);
    }
  }

  IconData get _defaultHeaderIcon {
    if (config.headerIcon != null) return config.headerIcon!;
    switch (config.type) {
      case SmartUIType.success:
        return Icons.check_rounded;
      case SmartUIType.error:
        return Icons.close_rounded;
      case SmartUIType.info:
        return Icons.info_outline_rounded;
      case SmartUIType.warning:
        return Icons.warning_amber_rounded;
      case SmartUIType.plain:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (config.style == SmartDialogStyle.withHeader) {
      return _buildWithHeader(context);
    }
    return _buildStandard(context);
  }

  Widget _buildWithHeader(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Dialog body
          Container(
            margin: const EdgeInsets.only(top: 44),
            decoration: BoxDecoration(
              color: config.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(config.borderRadius),
            ),
            padding:
                const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (config.title != null)
                  Text(
                    config.title!,
                    style: config.titleStyle ??
                        const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A)),
                    textAlign: TextAlign.center,
                  ),
                if (config.title != null) const SizedBox(height: 12),
                if (config.content != null)
                  config.content!
                else if (config.message != null)
                  Text(
                    config.message!,
                    style: config.messageStyle ??
                        const TextStyle(
                            fontSize: 15, color: Color(0xFF555555), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
                _buildButtons(context),
              ],
            ),
          ),
          // Floating circle header
          Positioned(
            top: 0,
            child: config.headerWidget ??
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: _typeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_defaultHeaderIcon,
                      color: Colors.white, size: 40),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandard(BuildContext context) {
    return AlertDialog(
      backgroundColor: config.backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius)),
      title: config.title != null
          ? Text(config.title!,
              style: config.titleStyle ??
                  const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1A1A1A)))
          : null,
      content: config.content ??
          (config.message != null
              ? Text(config.message!,
                  style: config.messageStyle ??
                      const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                          height: 1.5))
              : null),
      actions: config.buttons.isNotEmpty
          ? config.buttons
              .map((btn) => _buildActionButton(context, btn))
              .toList()
          : null,
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (config.buttons.isEmpty) return const SizedBox.shrink();

    return Row(
      children: config.buttons.map((btn) {
        final isLast = config.buttons.last == btn;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: isLast && config.buttons.length > 1 ? 8 : 0),
            child: btn.filled
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      btn.onPressed?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btn.fillColor ?? const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(btn.label),
                  )
                : OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      btn.onPressed?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: btn.textColor ?? const Color(0xFF555555),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(btn.label),
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, DialogButton btn) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        btn.onPressed?.call();
      },
      style: TextButton.styleFrom(
        foregroundColor: btn.textColor ??
            (btn.filled
                ? (btn.fillColor ?? const Color(0xFF1565C0))
                : const Color(0xFF1565C0)),
      ),
      child: Text(btn.label,
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}