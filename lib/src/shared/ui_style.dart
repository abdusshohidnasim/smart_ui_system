
/// Visual style/shape of the toast notification.
enum SmartToastStyle {
  /// Small pill — classic Android toast
  toast,

  /// Material snackbar at bottom
  snackbar,

  /// Full-width banner at top
  bannerTop,

  /// Full-width banner at bottom
  bannerBottom,
}

/// Dialog visual style.
enum SmartDialogStyle {
  /// Standard dialog with title + message + buttons
  standard,

  /// Dialog with large icon/image at top (floating header style)
  withHeader,

  /// Bottom sheet style dialog
  bottomSheet,
}