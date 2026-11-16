import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Reopening during the close animation', () {
    testWidgets('tapping the dial again while it is closing reopens it', (
      WidgetTester tester,
    ) async {
      var openCount = 0;
      var closeCount = 0;

      await pumpSpeedDialScaffold(
        tester,
        speedDial: SpeedDial(
          icon: Icons.add,
          onOpen: () => openCount++,
          onClose: () => closeCount++,
          children: [
            SpeedDialChild(child: const Icon(Icons.star), label: 'ReopenChild'),
          ],
        ),
      );

      final dialCenter = tester.getCenter(find.byType(SpeedDial));
      await tester.tapAt(dialCenter);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('ReopenChild'), findsOneWidget);

      await tester.tapAt(dialCenter);
      await tester.pump(const Duration(milliseconds: 50));
      expect(closeCount, 1);

      await tester.tapAt(dialCenter);
      await tester.pumpAndSettle();

      expect(
        find.text('ReopenChild'),
        findsOneWidget,
        reason: 'The dial must be open after the second tap',
      );
      expect(openCount, 2);
      expect(closeCount, 1);

      await tapOutsideAndExpectClosed(tester, hiddenText: 'ReopenChild');
    });

    testWidgets(
      'openCloseDial set back to true while closing keeps dial and notifier in sync',
      (WidgetTester tester) async {
        final isDialOpen = ValueNotifier<bool>(false);
        addTearDown(isDialOpen.dispose);

        await pumpSpeedDialScaffold(
          tester,
          speedDial: SpeedDial(
            icon: Icons.add,
            openCloseDial: isDialOpen,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.star),
                label: 'NotifierChild',
              ),
            ],
          ),
        );

        isDialOpen.value = true;
        await tester.pumpAndSettle();
        expect(find.text('NotifierChild'), findsOneWidget);

        isDialOpen.value = false;
        await tester.pump(const Duration(milliseconds: 50));
        isDialOpen.value = true;
        await tester.pumpAndSettle();

        expect(
          find.text('NotifierChild'),
          findsOneWidget,
          reason: 'A true notifier value must leave the dial open',
        );

        isDialOpen.value = false;
        await tester.pumpAndSettle();
        expect(
          find.text('NotifierChild'),
          findsNothing,
          reason: 'The notifier must still be able to close the dial',
        );
      },
    );
  });
}
