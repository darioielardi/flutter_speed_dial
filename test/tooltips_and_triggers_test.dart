import 'dart:ui';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Tooltips, callbacks, and triggers', () {
    testWidgets(
        'shows tooltips on hover when closed and open, fires open/close callbacks, and closes on child tap',
        (WidgetTester tester) async {
      const fabTooltip = 'Open Speed Dial';
      const childTooltip = 'Child tooltip';
      var tappedFirstChild = false;
      var openCallbackCount = 0;
      var closeCallbackCount = 0;

      await pumpSpeedDialScaffold(
        tester,
        speedDial: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          tooltip: fabTooltip,
          onOpen: () => openCallbackCount++,
          onClose: () => closeCallbackCount++,
          children: [
            SpeedDialChild(
              child: const Tooltip(
                message: childTooltip,
                child: Icon(Icons.accessibility),
              ),
              label: 'First',
              onTap: () => tappedFirstChild = true,
            ),
            SpeedDialChild(
              child: const Icon(Icons.brush),
              label: 'Second',
            ),
          ],
        ),
      );

      final dialButtonCenter = tester.getCenter(find.byType(SpeedDial));
      final mousePointer =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mousePointer.addPointer(location: Offset.zero);
      addTearDown(mousePointer.removePointer);

      await hoverAndExpectTooltip(
        tester,
        mousePointer: mousePointer,
        target: dialButtonCenter,
        expectedTooltip: fabTooltip,
        reason: 'Hovering over closed dial button should show the FAB tooltip',
      );

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(openCallbackCount, 1, reason: 'Opening dial should invoke onOpen');
      expect(closeCallbackCount, 0);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);

      await hoverAndExpectTooltip(
        tester,
        mousePointer: mousePointer,
        target: tester.getCenter(find.byIcon(Icons.accessibility)),
        expectedTooltip: childTooltip,
        reason: 'Hovering over child icon should show the child tooltip',
      );

      await hoverAndExpectTooltip(
        tester,
        mousePointer: mousePointer,
        target: dialButtonCenter,
        expectedTooltip: fabTooltip,
        reason:
            'Hovering back over open dial button should still show FAB tooltip',
      );

      await tapAndSettle(tester, find.text('First'));
      expect(tappedFirstChild, isTrue);
      expect(
        closeCallbackCount,
        1,
        reason: 'Tapping a child should close the dial and invoke onClose',
      );
      expect(find.text('First'), findsNothing);
    });

    testWidgets(
        'openCloseDial ValueNotifier, onOpenBuilder, and dialRoot stay in sync',
        (WidgetTester tester) async {
      final isDialOpen = ValueNotifier<bool>(false);
      addTearDown(isDialOpen.dispose);
      var openBuilderCallCount = 0;

      await pumpSpeedDialScaffold(
        tester,
        speedDial: SpeedDial(
          openCloseDial: isDialOpen,
          onOpenBuilder: (context) async {
            openBuilderCallCount++;
            return [
              SpeedDialChild(
                child: const Icon(Icons.bolt),
                label: 'Dynamic-$openBuilderCallCount',
              ),
            ];
          },
          dialRoot: (context, isOpen, toggleChildren) => ElevatedButton(
            onPressed: toggleChildren,
            child: Text(isOpen ? 'CustomOpen' : 'CustomClosed'),
          ),
          children: [],
        ),
      );

      expect(find.text('CustomClosed'), findsOneWidget);

      isDialOpen.value = true;
      await tester.pumpAndSettle();
      expect(openBuilderCallCount, 1);
      expect(find.text('CustomOpen'), findsOneWidget);
      expect(find.text('Dynamic-1'), findsOneWidget);

      await tapAndSettle(tester, find.text('Dynamic-1'));
      expect(isDialOpen.value, isFalse);
      expect(find.text('CustomClosed'), findsOneWidget);
      expect(find.text('Dynamic-1'), findsNothing);

      await tapAndSettle(tester, find.text('CustomClosed'));
      expect(openBuilderCallCount, 2);
      expect(isDialOpen.value, isTrue);
      expect(find.text('Dynamic-2'), findsOneWidget);

      isDialOpen.value = false;
      await tester.pumpAndSettle();
      expect(find.text('Dynamic-2'), findsNothing);
    });

    testWidgets('onPress handles tap while long-press opens the dial',
        (WidgetTester tester) async {
      var tapCallbackCount = 0;

      await pumpSpeedDialScaffold(
        tester,
        speedDial: SpeedDial(
          icon: Icons.add,
          onPress: () => tapCallbackCount++,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.bolt),
              label: 'LongPressChild',
            ),
          ],
        ),
      );

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(tapCallbackCount, 1);
      expect(find.text('LongPressChild'), findsNothing);

      await tester.longPress(find.byType(SpeedDial));
      await tester.pumpAndSettle();
      expect(tapCallbackCount, 1);
      expect(find.text('LongPressChild'), findsOneWidget);
    });
  });
}

Future<void> hoverAndExpectTooltip(
  WidgetTester tester, {
  required TestGesture mousePointer,
  required Offset target,
  required String expectedTooltip,
  required String reason,
}) async {
  await mousePointer.moveTo(target);
  await tester.pump(const Duration(seconds: 2));
  expect(find.text(expectedTooltip), findsOneWidget, reason: reason);
}
