import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ui_system/smart_ui_system.dart';

void main() {
  group('SmartUIType', () {
    test('all types exist', () {
      expect(SmartUIType.values.length, 5);
    });
  });

  group('SmartToastStyle', () {
    test('all styles exist', () {
      expect(SmartToastStyle.values.length, 4);
    });
  });

  group('SmartUIPosition', () {
    test('all positions exist', () {
      expect(SmartUIPosition.values.length, 3);
    });
  });

  group('ToastConfig factories', () {
    test('success factory sets correct type', () {
      final config = ToastConfig.success(message: 'Test');
      expect(config.type, SmartUIType.success);
      expect(config.style, SmartToastStyle.snackbar);
    });

    test('error factory sets showCloseButton true by default', () {
      final config = ToastConfig.error(message: 'Test');
      expect(config.type, SmartUIType.error);
      expect(config.showCloseButton, true);
    });
  });

  group('DialogConfig factories', () {
    test('confirm factory creates 2 buttons', () {
      final config = DialogConfig.confirm(
        title: 'Title',
        message: 'Message',
      );
      expect(config.buttons.length, 2);
    });

    test('alert factory creates 1 button', () {
      final config = DialogConfig.alert(
        title: 'Title',
        message: 'Message',
      );
      expect(config.buttons.length, 1);
    });

    test('destructive uses error type', () {
      final config = DialogConfig.destructive(
        title: 'Delete?',
        message: 'Cannot undo',
      );
      expect(config.type, SmartUIType.error);
    });
  });

  group('DialogButton factories', () {
    test('cancel is not filled', () {
      final btn = DialogButton.cancel();
      expect(btn.filled, false);
    });

    test('confirm is filled', () {
      final btn = DialogButton.confirm();
      expect(btn.filled, true);
    });

    test('destructive is filled red', () {
      final btn = DialogButton.destructive();
      expect(btn.filled, true);
      expect(btn.fillColor, const Color(0xFFC62828));
    });
  });

  group('BottomSheetConfig', () {
    test('items store correctly', () {
      const item = BottomSheetItem(
        icon: Icons.check,
        label: 'Test',
        value: true,
      );
      expect(item.value, true);
      expect(item.label, 'Test');
    });
  });

  group('SmartToast', () {
    testWidgets('calls onDismiss on auto-dismiss', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      var dismissCount = 0;
      SmartToast.show(
        ctx,
        config: ToastConfig(
          message: 'Hi',
          duration: const Duration(milliseconds: 10),
          animationDuration: const Duration(milliseconds: 10),
          onDismiss: () => dismissCount++,
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 30));

      expect(dismissCount, 1);
    });

    testWidgets('calls onDismiss only once when manually dismissed',
        (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      var dismissCount = 0;
      SmartToast.show(
        ctx,
        config: ToastConfig(
          message: 'Hi',
          showCloseButton: true,
          duration: const Duration(milliseconds: 80),
          animationDuration: const Duration(milliseconds: 10),
          onDismiss: () => dismissCount++,
        ),
      );

      await tester.pump();
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(dismissCount, 1);
    });
  });
}
