import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Backdrop hit-testing', () {
    testWidgets(
        'allows tapping underlying widgets when renderOverlay is false',
        (WidgetTester tester) async {
      var behindButtonTapCount = 0;

      await pumpBackdropHitTestApp(
        tester,
        renderOverlay: false,
        onBehindPressed: () => behindButtonTapCount++,
      );

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(find.text('Item'), findsOneWidget);

      await tapAndSettle(tester, find.text('Behind'));
      expect(
        behindButtonTapCount,
        1,
        reason:
            'Underlying widget should receive taps when renderOverlay is false',
      );
      expect(find.text('Item'), findsOneWidget);

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(find.text('Item'), findsNothing);
    });

    testWidgets(
        'blocks underlying taps and ignores backdrop tap when renderOverlay and closeManually are true',
        (WidgetTester tester) async {
      var behindButtonTapCount = 0;

      await pumpBackdropHitTestApp(
        tester,
        renderOverlay: true,
        onBehindPressed: () => behindButtonTapCount++,
      );

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(find.text('Item'), findsOneWidget);

      await tester.tap(find.text('Behind'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(
        behindButtonTapCount,
        0,
        reason: 'Backdrop should intercept taps when renderOverlay is true',
      );
      expect(find.text('Item'), findsOneWidget);

      await tapAtAndSettle(tester, tester.getCenter(find.byType(SpeedDial)));
      expect(find.text('Item'), findsNothing);
    });
  });
}

Future<void> pumpBackdropHitTestApp(
  WidgetTester tester, {
  required bool renderOverlay,
  required VoidCallback onBehindPressed,
}) async {
  await pumpSpeedDialScaffold(
    tester,
    body: Align(
      alignment: Alignment.topLeft,
      child: ElevatedButton(
        onPressed: onBehindPressed,
        child: const Text('Behind'),
      ),
    ),
    speedDial: SpeedDial(
      icon: Icons.add,
      renderOverlay: renderOverlay,
      closeManually: true,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.star),
          label: 'Item',
        ),
      ],
    ),
  );
}
