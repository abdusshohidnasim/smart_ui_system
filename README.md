# smart_ui_system

A fully customizable Flutter UI package — beautiful **toasts**, **dialogs**, and **bottom sheets** in one place.

---

## Features

- **SmartToast** — Android toast, snackbar, banners (top/bottom), success/error/info/warning
- **SmartDialog** — Standard dialog, floating header style, destructive confirm
- **SmartBottomSheet** — Toggle list, custom content
- Fully customizable colors, icons, text styles, border radius
- Smooth slide + fade animations
- Action buttons, close buttons, auto-dismiss

---

## Installation

```yaml
dependencies:
  smart_ui_system: ^0.0.1
```

```dart
import 'package:smart_ui_system/smart_ui_system.dart';
```

---

## Toast

```dart
// Android-style toast
SmartToast.toast(context, message: "Hello. I'm a toast!");

// Snackbar
SmartToast.success(context, title: 'Success', message: 'Data saved!');
SmartToast.error(context, title: 'Failed', message: 'Something went wrong!');
SmartToast.info(context, message: 'New message received');
SmartToast.warning(context, message: 'Battery low!');

// Banner
SmartToast.success(context, message: 'Done!', style: SmartToastStyle.bannerTop);

// With action button
SmartToast.show(context, config: ToastConfig(
  message: 'Message deleted',
  actionLabel: 'UNDO',
  onActionPressed: () => restoreMessage(),
));

// Fully custom
SmartToast.show(context, config: ToastConfig(
  message: 'Downloading...',
  title: 'Download',
  backgroundColor: Colors.purple,
  leadingIcon: Icon(Icons.download, color: Colors.white),
  actionLabel: 'CANCEL',
  onActionPressed: () {},
  style: SmartToastStyle.snackbar,
  duration: Duration(seconds: 5),
));
```

---

## Dialog

```dart
// Confirm/Cancel
SmartDialog.confirm(context,
  title: 'Privacy Info',
  message: 'This backup may contain sensitive data.',
  onConfirm: () => doBackup(),
);

// Alert with icon header
SmartDialog.alert(context,
  title: 'Success',
  message: 'Your file was saved.',
  type: SmartUIType.success,
);

// Delete confirmation
SmartDialog.destructive(context,
  title: 'Delete account?',
  message: 'This cannot be undone.',
  onDelete: () => deleteAccount(),
);

// Fully custom
SmartDialog.show(context, config: DialogConfig(
  title: 'Here goes title',
  message: 'Here goes content.',
  style: SmartDialogStyle.withHeader,
  type: SmartUIType.warning,
  headerIcon: Icons.chat_bubble_outline_rounded,
  buttons: [
    DialogButton.cancel(),
    DialogButton(label: 'Done', textColor: Colors.blue),
  ],
));
```

---

## Bottom Sheet

```dart
// Toggle list
SmartBottomSheet.showToggles(context,
  title: 'Filter tasks',
  items: [
    BottomSheetItem(icon: Icons.check_circle_outline, label: 'Total Task', value: true),
    BottomSheetItem(icon: Icons.monitor_outlined, label: 'Due Soon'),
    BottomSheetItem(icon: Icons.check_box, label: 'Completed'),
    BottomSheetItem(icon: Icons.flag_outlined, label: 'Working On'),
  ],
  onToggle: (index, value) => print('$index → $value'),
);

// Custom content
SmartBottomSheet.show(context, config: BottomSheetConfig(
  title: 'Bringing guests?',
  content: MyCustomWidget(),
));
```

---

## API Reference

### ToastConfig parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `message` | `String` | required | Main message |
| `title` | `String?` | null | Bold title |
| `type` | `SmartUIType` | `plain` | Color theme |
| `style` | `SmartToastStyle` | `toast` | Shape/position |
| `position` | `SmartUIPosition` | `bottom` | Screen position |
| `duration` | `Duration` | 3s | Auto-dismiss time |
| `backgroundColor` | `Color?` | — | Override color |
| `leadingIcon` | `Widget?` | — | Custom icon widget |
| `actionLabel` | `String?` | — | Action button text |
| `showCloseButton` | `bool` | false | Show × button |
| `borderRadius` | `double` | 12 | Corner radius |

### DialogConfig parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String?` | — | Dialog title |
| `message` | `String?` | — | Message text |
| `content` | `Widget?` | — | Custom content widget |
| `style` | `SmartDialogStyle` | `standard` | Visual style |
| `type` | `SmartUIType` | `info` | Header color theme |
| `headerIcon` | `IconData?` | — | Icon in header circle |
| `buttons` | `List<DialogButton>` | `[]` | Action buttons |
| `barrierDismissible` | `bool` | true | Tap outside to close |

---

## License

MIT