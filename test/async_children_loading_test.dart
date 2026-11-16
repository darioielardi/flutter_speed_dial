import 'dart:async';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Async children loading', () {
    testWidgets(
      'rapid taps while onOpenBuilder is pending load children once',
      (WidgetTester tester) async {
        final isDialOpen = ValueNotifier<bool>(false);
        addTearDown(isDialOpen.dispose);

        var builderCalls = 0;
        final pending = Completer<List<SpeedDialChild>>();

        await pumpSpeedDialScaffold(
          tester,
          speedDial: SpeedDial(
            icon: Icons.add,
            openCloseDial: isDialOpen,
            children: [],
            onOpenBuilder: (context) {
              builderCalls++;
              return pending.future;
            },
          ),
        );

        await tester.tap(find.byType(SpeedDial));
        await tester.pump();
        await tester.tap(find.byType(SpeedDial));
        await tester.pump();

        expect(
          builderCalls,
          1,
          reason: 'A second tap must not start another children load',
        );

        pending.complete([
          SpeedDialChild(child: const Icon(Icons.bolt), label: 'LoadedChild'),
        ]);
        await tester.pumpAndSettle();

        expect(find.text('LoadedChild'), findsOneWidget);
        expect(
          isDialOpen.value,
          isTrue,
          reason: 'The dial must stay open after the load finishes',
        );

        await tapAndSettle(tester, find.text('LoadedChild'));
        expect(find.text('LoadedChild'), findsNothing);
        expect(isDialOpen.value, isFalse);
      },
    );

    testWidgets('a later open runs onOpenBuilder again after a load finished', (
      WidgetTester tester,
    ) async {
      var builderCalls = 0;

      await pumpSpeedDialScaffold(
        tester,
        speedDial: SpeedDial(
          icon: Icons.add,
          children: [],
          onOpenBuilder: (context) async {
            builderCalls++;
            return [
              SpeedDialChild(
                child: const Icon(Icons.bolt),
                label: 'Load-$builderCalls',
              ),
            ];
          },
        ),
      );

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(builderCalls, 1);
      expect(find.text('Load-1'), findsOneWidget);

      await tapAndSettle(tester, find.text('Load-1'));
      expect(find.text('Load-1'), findsNothing);

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(
        builderCalls,
        2,
        reason: 'The loading guard must be released after a completed load',
      );
      expect(find.text('Load-2'), findsOneWidget);
    });
  });
}
