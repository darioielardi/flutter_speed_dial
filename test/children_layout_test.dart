import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Children layout and directions', () {
    for (final direction in SpeedDialDirection.values) {
      testWidgets(
          'positions and orders children in ${direction.name} direction',
          (WidgetTester tester) async {
        final firstLabel = 'First-${direction.name}';
        final secondLabel = 'Second-${direction.name}';

        await pumpSpeedDialScaffold(
          tester,
          location: FloatingActionButtonLocation.centerFloat,
          speedDial: SpeedDial(
            icon: Icons.add,
            direction: direction,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.looks_one),
                label: firstLabel,
              ),
              SpeedDialChild(
                child: const Icon(Icons.looks_two),
                label: secondLabel,
              ),
            ],
          ),
        );

        await tapAndSettle(tester, find.byType(SpeedDial));
        expectChildrenOrderedInDirection(
          tester,
          direction: direction,
          firstIcon: Icons.looks_one,
          secondIcon: Icons.looks_two,
        );

        await tapOutsideAndExpectClosed(tester, hiddenText: firstLabel);
      });
    }

    testWidgets(
        'opens immediately with isOpenOnStart and flips label side with switchLabelPosition',
        (WidgetTester tester) async {
      await pumpStartOpenDial(tester, switchLabelPosition: false);
      expectChildLabelSide(
        tester,
        icon: Icons.edit,
        label: 'Edit',
        labelOnLeft: true,
        reason: 'Default switchLabelPosition: false places label on the left',
      );

      await pumpStartOpenDial(tester, switchLabelPosition: true);
      expectChildLabelSide(
        tester,
        icon: Icons.edit,
        label: 'Edit',
        labelOnLeft: false,
        reason: 'switchLabelPosition: true moves label to the right',
      );

      await tapOutsideAndExpectClosed(tester, hiddenText: 'Edit');
    });
  });
}

Future<void> pumpStartOpenDial(
  WidgetTester tester, {
  required bool switchLabelPosition,
}) async {
  await pumpSpeedDialScaffold(
    tester,
    location: FloatingActionButtonLocation.centerFloat,
    speedDial: SpeedDial(
      icon: Icons.add,
      isOpenOnStart: true,
      switchLabelPosition: switchLabelPosition,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.edit),
          label: 'Edit',
        ),
      ],
    ),
  );
  await tester.pumpAndSettle();
}

void expectChildrenOrderedInDirection(
  WidgetTester tester, {
  required SpeedDialDirection direction,
  required IconData firstIcon,
  required IconData secondIcon,
}) {
  final dialRect = tester.getRect(find.byType(SpeedDial));
  final firstChildIconRect = tester.getRect(find.byIcon(firstIcon));
  final secondChildIconRect = tester.getRect(find.byIcon(secondIcon));

  if (direction.isUp || direction.isDown) {
    expect(firstChildIconRect.center.dx, closeTo(dialRect.center.dx, 8.0));
    expect(secondChildIconRect.center.dx, closeTo(dialRect.center.dx, 8.0));
  } else {
    expect(
      firstChildIconRect.center.dy,
      inInclusiveRange(dialRect.top, dialRect.bottom),
    );
    expect(
      secondChildIconRect.center.dy,
      inInclusiveRange(dialRect.top, dialRect.bottom),
    );
  }

  switch (direction) {
    case SpeedDialDirection.up:
      expect(firstChildIconRect.bottom, lessThanOrEqualTo(dialRect.top));
      expect(secondChildIconRect.bottom, lessThan(firstChildIconRect.top));
    case SpeedDialDirection.down:
      expect(firstChildIconRect.top, greaterThanOrEqualTo(dialRect.bottom));
      expect(secondChildIconRect.top, greaterThan(firstChildIconRect.bottom));
    case SpeedDialDirection.left:
      expect(firstChildIconRect.right, lessThanOrEqualTo(dialRect.left));
      expect(secondChildIconRect.right, lessThan(firstChildIconRect.left));
    case SpeedDialDirection.right:
      expect(firstChildIconRect.left, greaterThanOrEqualTo(dialRect.right));
      expect(secondChildIconRect.left, greaterThan(firstChildIconRect.right));
  }
}

void expectChildLabelSide(
  WidgetTester tester, {
  required IconData icon,
  required String label,
  required bool labelOnLeft,
  required String reason,
}) {
  final dialRect = tester.getRect(find.byType(SpeedDial));
  final childIconRect = tester.getRect(find.byIcon(icon));
  final childLabelRect = tester.getRect(find.text(label));

  expect(childIconRect.center.dx, closeTo(dialRect.center.dx, 8.0));
  if (labelOnLeft) {
    expect(childLabelRect.right, lessThan(childIconRect.left), reason: reason);
  } else {
    expect(childLabelRect.left, greaterThan(childIconRect.right), reason: reason);
  }
}
