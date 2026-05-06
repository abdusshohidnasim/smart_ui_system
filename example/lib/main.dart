import 'package:flutter/material.dart';
import 'package:smart_ui_system/smart_ui_system.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart UI System Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart UI System Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── TOAST ──────────────────────────────────────────────────────────
          _Section('Toast (Android style)', [
            _Btn('Plain toast', () => SmartToast.toast(context, message: "Hello. I'm a toast!")),
            _Btn('Toast at top', () => SmartToast.toast(context, message: 'Top toast!', position: SmartUIPosition.top)),
          ]),

          _Section('Snackbar', [
            _Btn('Success', () => SmartToast.success(context, title: 'Success', message: 'Data saved successfully!')),
            _Btn('Error + close', () => SmartToast.error(context, title: 'Failed', message: 'Failed to save data!', showCloseButton: true)),
            _Btn('Info', () => SmartToast.info(context, title: 'New message received', message: 'You have 3 unread messages')),
            _Btn('Warning', () => SmartToast.warning(context, message: 'Battery is low!')),
            _Btn('With UNDO action', () => SmartToast.show(context, config: ToastConfig(
              message: 'Message deleted',
              actionLabel: 'UNDO',
              onActionPressed: () => SmartToast.success(context, message: 'Restored!'),
            ))),
          ]),

          _Section('Banner', [
            _Btn('Banner top', () => SmartToast.success(context, title: 'Download', message: 'File ready!', style: SmartToastStyle.bannerTop)),
            _Btn('Banner bottom', () => SmartToast.info(context, title: 'Update', message: 'New version available', style: SmartToastStyle.bannerBottom)),
          ]),

          _Section('Custom Toast', [
            _Btn('Custom color + icon', () => SmartToast.show(context, config: ToastConfig(
              message: 'Downloading your file...',
              title: 'Download',
              backgroundColor: const Color(0xFF4A148C),
              leadingIcon: const Icon(Icons.download_rounded, color: Colors.white),
              actionLabel: 'CANCEL',
              onActionPressed: () {},
            ))),
          ]),

          // ── DIALOG ─────────────────────────────────────────────────────────
          _Section('Dialog', [
            _Btn('Confirm dialog', () => SmartDialog.confirm(
              context,
              title: 'Privacy Info',
              message: 'The backup created with this functionality may contain some sensitive data.',
              onConfirm: () => SmartToast.success(context, message: 'Confirmed!'),
            )),
            _Btn('Success alert (with header)', () => SmartDialog.alert(
              context,
              title: 'Success',
              message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
              type: SmartUIType.success,
              buttonLabel: 'Okay',
            )),
            _Btn('Error alert', () => SmartDialog.alert(
              context,
              title: 'Something went wrong',
              message: 'Please try again later.',
              type: SmartUIType.error,
            )),
            _Btn('Delete confirm', () => SmartDialog.destructive(
              context,
              title: 'Delete account?',
              message: 'This action cannot be undone.',
              onDelete: () => SmartToast.error(context, message: 'Account deleted'),
            )),
            _Btn('Custom dialog (icon + custom content)', () => SmartDialog.show(
              context,
              config: DialogConfig(
                title: 'Here goes title',
                message: 'Here goes the content of dialog. Here goes the content of dialog.',
                style: SmartDialogStyle.withHeader,
                type: SmartUIType.warning,
                headerIcon: Icons.chat_bubble_outline_rounded,
                buttons: [
                  DialogButton.cancel(label: 'Cancel'),
                  DialogButton(label: 'Done', textColor: const Color(0xFF1565C0)),
                ],
              ),
            )),
          ]),

          // ── BOTTOM SHEET ───────────────────────────────────────────────────
          _Section('Bottom Sheet', [
            _Btn('Toggle list (filter)', () => SmartBottomSheet.showToggles(
              context,
              title: 'Filter tasks',
              items: [
                const BottomSheetItem(icon: Icons.check_circle_outline, label: 'Total Task', value: true),
                const BottomSheetItem(icon: Icons.monitor_outlined, label: 'Due Soon'),
                const BottomSheetItem(icon: Icons.check_box, label: 'Completed'),
                const BottomSheetItem(icon: Icons.flag_outlined, label: 'Working On'),
              ],
              onToggle: (i, val) => SmartToast.toast(context, message: 'Item $i → $val'),
            )),
            _Btn('Custom content', () => SmartBottomSheet.show(
              context,
              config: BottomSheetConfig(
                title: 'Bringing guests?',
                content: _GuestPicker(),
              ),
            )),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
        const Divider(),
        ...children,
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Btn(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
          alignment: Alignment.centerLeft,
        ),
        child: Text(label),
      ),
    );
  }
}

// Simple guest counter widget for the bottom sheet demo
class _GuestPicker extends StatefulWidget {
  @override
  State<_GuestPicker> createState() => _GuestPickerState();
}

class _GuestPickerState extends State<_GuestPicker> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _count > 0 ? () => setState(() => _count--) : null,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 24),
            Text('$_count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(width: 24),
            IconButton(
              onPressed: () => setState(() => _count++),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          child: const Text('NEXT'),
        ),
      ],
    );
  }
}