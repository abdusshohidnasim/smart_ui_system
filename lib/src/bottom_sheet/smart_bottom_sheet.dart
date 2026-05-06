import 'package:flutter/material.dart';
import 'bottom_sheet_config.dart';


class SmartBottomSheet {
  SmartBottomSheet._();

  /// Show a bottom sheet with toggle rows.
  static Future<void> showToggles(
    BuildContext context, {
    String? title,
    required List<BottomSheetItem> items,
    void Function(int index, bool value)? onToggle,
    Color? backgroundColor,
    double borderRadius = 20,
    Color activeToggleColor = const Color(0xFF1565C0),
  }) {
    final resolvedItems = items
        .map(
          (e) => BottomSheetItem(
            icon: e.icon,
            label: e.label,
            value: e.value,
            activeColor: e.activeColor ?? activeToggleColor,
          ),
        )
        .toList(growable: false);

    return show(
      context,
      config: BottomSheetConfig(
        title: title,
        items: resolvedItems,
        onItemToggle: onToggle,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Show any bottom sheet using [BottomSheetConfig].
  static Future<void> show(
    BuildContext context, {
    required BottomSheetConfig config,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: config.isDismissible,
      enableDrag: config.enableDrag,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SmartBottomSheetWidget(config: config),
    );
  }
}

// ─── Internal bottom sheet widget ─────────────────────────────────────────────

class _SmartBottomSheetWidget extends StatefulWidget {
  final BottomSheetConfig config;

  const _SmartBottomSheetWidget({required this.config});

  @override
  State<_SmartBottomSheetWidget> createState() =>
      _SmartBottomSheetWidgetState();
}

class _SmartBottomSheetWidgetState extends State<_SmartBottomSheetWidget> {
  late List<bool> _toggleValues;

  @override
  void initState() {
    super.initState();
    _toggleValues =
        widget.config.items?.map((e) => e.value).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final bg = c.backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.white);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(c.borderRadius),
          topRight: Radius.circular(c.borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (c.showHandle) ...[
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha((0.4 * 255).round()),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),
          ],

          if (c.title != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                c.title!,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),

          // Toggle items
          if (c.items != null)
            ...List.generate(c.items!.length, (i) {
              final item = c.items![i];
              final isLast = i == c.items!.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 4),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 22),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(item.label,
                              style: const TextStyle(fontSize: 16)),
                        ),
                        Switch(
                          value: _toggleValues[i],
                          activeThumbColor: 
                              item.activeColor ?? const Color(0xFF1565C0),
                          onChanged: (val) {
                            setState(() => _toggleValues[i] = val);
                            c.onItemToggle?.call(i, val);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 20, endIndent: 20),
                ],
              );
            }),

          // Custom content
          if (c.content != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: c.content!,
            ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}