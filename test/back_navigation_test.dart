import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Back navigation (closeDialOnPop)', () {
    testWidgets(
        'closes open dial on first back navigation and pops route on second when closeDialOnPop is true',
        (WidgetTester tester) async {
      await pushRouteWithSpeedDial(tester, closeDialOnPop: true);

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(find.text('PopChild'), findsOneWidget);

      await triggerBackNavigation(tester);
      expect(
        find.text('Second Page'),
        findsOneWidget,
        reason: 'First back navigation should keep the route open',
      );
      expect(
        find.text('PopChild'),
        findsNothing,
        reason: 'First back navigation should close the open dial',
      );

      await triggerBackNavigation(tester);
      expectReturnedToInitialRoute();
    });

    testWidgets(
        'pops route immediately even while dial is open when closeDialOnPop is false',
        (WidgetTester tester) async {
      await pushRouteWithSpeedDial(tester, closeDialOnPop: false);

      await tapAndSettle(tester, find.byType(SpeedDial));
      expect(find.text('PopChild'), findsOneWidget);

      await triggerBackNavigation(tester);
      expectReturnedToInitialRoute();
    });
  });
}

Future<void> pushRouteWithSpeedDial(
  WidgetTester tester, {
  required bool closeDialOnPop,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    body: const Text('Second Page'),
                    floatingActionButton: SpeedDial(
                      icon: Icons.add,
                      closeDialOnPop: closeDialOnPop,
                      children: [
                        SpeedDialChild(
                          child: const Icon(Icons.close),
                          label: 'PopChild',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Text('Push'),
          ),
        ),
      ),
    ),
  );

  await tapAndSettle(tester, find.text('Push'));
  expect(find.text('Second Page'), findsOneWidget);
}

Future<void> triggerBackNavigation(WidgetTester tester) async {
  await Navigator.of(tester.element(find.byType(SpeedDial))).maybePop();
  await tester.pumpAndSettle();
}

void expectReturnedToInitialRoute() {
  expect(find.text('Second Page'), findsNothing);
  expect(find.text('PopChild'), findsNothing);
  expect(find.text('Push'), findsOneWidget);
}
