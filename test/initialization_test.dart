import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Initialization', () {
    testWidgets(
      'does not leave a pending timer when the dial is never opened',
      (WidgetTester tester) async {
        await pumpSpeedDialScaffold(
          tester,
          speedDial: SpeedDial(
            icon: Icons.add,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.star),
                label: 'TimerChild',
              ),
            ],
          ),
        );

        expect(find.byType(SpeedDial), findsOneWidget);
        expect(find.text('TimerChild'), findsNothing);
      },
    );

    testWidgets('isOpenOnStart still opens on the first frame', (
      WidgetTester tester,
    ) async {
      await pumpSpeedDialScaffold(
        tester,
        speedDial: SpeedDial(
          icon: Icons.add,
          isOpenOnStart: true,
          children: [
            SpeedDialChild(child: const Icon(Icons.star), label: 'StartChild'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('StartChild'), findsOneWidget);
    });
  });
}
