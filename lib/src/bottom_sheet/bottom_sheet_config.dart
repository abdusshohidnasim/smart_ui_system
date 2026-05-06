import 'package:flutter/material.dart';

/// Configuration for [SmartBottomSheet].
class BottomSheetConfig {
  /// Sheet title text.
  final String? title;

  /// Content widget inside the sheet.
  final Widget? content;

  /// List items — shown as toggle rows with icon + label + switch.
  final List<BottomSheetItem>? items;

  /// Called when item toggle changes. Receives item index and new value.
  final void Function(int index, bool value)? onItemToggle;

  /// Sheet background color.
  final Color? backgroundColor;

  /// Corner radius of top corners.
  final double borderRadius;

  /// Show drag handle at top.
  final bool showHandle;

  /// Whether tapping outside dismisses.
  final bool isDismissible;

  /// Whether sheet can be dragged down to close.
  final bool enableDrag;

  const BottomSheetConfig({
    this.title,
    this.content,
    this.items,
    this.onItemToggle,
    this.backgroundColor,
    this.borderRadius = 20,
    this.showHandle = true,
    this.isDismissible = true,
    this.enableDrag = true,
  });
}

/// A toggle row item for [BottomSheetConfig.items].
class BottomSheetItem {
  /// Row icon.
  final IconData icon;

  /// Row label.
  final String label;

  /// Initial toggle state.
  final bool value;

  /// Active toggle color.
  final Color? activeColor;

  const BottomSheetItem({
    required this.icon, 
    required this.label,
    this.value = false,
    this.activeColor,
  });
}