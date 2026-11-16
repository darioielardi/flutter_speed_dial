import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/speed_dial_test_helpers.dart';

void main() {
  group('Scaffold FAB integration', () {
    testWidgets(
        'supports FloatingActionButtonLocations and BottomAppBar notch geometry',
        (WidgetTester tester) async {
      const fabSize = 56.0;
      const notchMargin = 8.0;
      const expectedNotchedDiameter = fabSize + 2 * notchMargin;
      const dockedLocations = [
        FloatingActionButtonLocation.startDocked,
        FloatingActionButtonLocation.centerDocked,
        FloatingActionButtonLocation.endDocked,
      ];
      final allLocations = [
        ...dockedLocations,
        FloatingActionButtonLocation.endFloat,
        FloatingActionButtonLocation.endTop,
      ];
      final dialCentersByLocation = <FloatingActionButtonLocation, Offset>{};

      for (final location in allLocations) {
        Rect? recordedNotchGuestRect;

        await pumpSpeedDialScaffold(
          tester,
          scaffoldKey: ValueKey(location),
          location: location,
          speedDial: SpeedDial(
            icon: Icons.add,
            direction: location == FloatingActionButtonLocation.endTop
                ? SpeedDialDirection.down
                : SpeedDialDirection.up,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.check),
                label: 'Action',
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: _RecordingNotchedShape(
              onGetOuterPath: (guest) => recordedNotchGuestRect = guest,
            ),
            notchMargin: notchMargin,
            child: const SizedBox(height: fabSize),
          ),
        );

        final dialRect = tester.getRect(find.byType(SpeedDial));
        dialCentersByLocation[location] = dialRect.center;
        expect(dialRect.width, closeTo(fabSize, 0.01));
        expect(dialRect.height, closeTo(fabSize, 0.01));

        if (dockedLocations.contains(location)) {
          final bottomAppBarTopLeft =
              tester.getTopLeft(find.byType(BottomAppBar));
          expect(recordedNotchGuestRect, isNotNull);
          expect(
            recordedNotchGuestRect!.width,
            closeTo(expectedNotchedDiameter, 0.01),
          );
          expect(
            recordedNotchGuestRect!.height,
            closeTo(expectedNotchedDiameter, 0.01),
          );
          final globalNotchCenter =
              recordedNotchGuestRect!.center + bottomAppBarTopLeft;
          expect(globalNotchCenter.dx, closeTo(dialRect.center.dx, 0.1));
          expect(globalNotchCenter.dy, closeTo(dialRect.center.dy, 0.1));
        }

        await tapAndSettle(tester, find.byType(SpeedDial));
        expect(find.text('Action'), findsOneWidget);
        await tapOutsideAndExpectClosed(tester, hiddenText: 'Action');
      }

      expect(
        dialCentersByLocation[FloatingActionButtonLocation.startDocked]!.dx,
        lessThan(
          dialCentersByLocation[FloatingActionButtonLocation.centerDocked]!.dx,
        ),
      );
      expect(
        dialCentersByLocation[FloatingActionButtonLocation.centerDocked]!.dx,
        lessThan(
          dialCentersByLocation[FloatingActionButtonLocation.endDocked]!.dx,
        ),
      );
      expect(
        dialCentersByLocation[FloatingActionButtonLocation.endTop]!.dy,
        lessThan(
          dialCentersByLocation[FloatingActionButtonLocation.endFloat]!.dy,
        ),
      );
    });

    testWidgets(
        'children and dial tap target move together when scrolled while open',
        (WidgetTester tester) async {
      const scrollDistance = 100.0;
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);

      await pumpSpeedDialScaffold(
        tester,
        body: ListView(
          controller: scrollController,
          children: [
            const SizedBox(height: 200),
            Center(
              child: SpeedDial(
                icon: Icons.add,
                closeManually: true,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.star),
                    label: 'ScrolledChild',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1000),
          ],
        ),
      );

      final initialDialCenter = tester.getCenter(find.byType(SpeedDial));
      await tapAtAndSettle(tester, initialDialCenter);

      final initialDialTop = tester.getTopLeft(find.byType(SpeedDial)).dy;
      final initialChildBottom =
          tester.getBottomLeft(find.text('ScrolledChild')).dy;

      scrollController.jumpTo(scrollDistance);
      await tester.pumpAndSettle();

      final scrolledDialTop = tester.getTopLeft(find.byType(SpeedDial)).dy;
      final scrolledChildBottom =
          tester.getBottomLeft(find.text('ScrolledChild')).dy;
      expect(scrolledDialTop, closeTo(initialDialTop - scrollDistance, 0.1));
      expect(
        scrolledChildBottom,
        closeTo(initialChildBottom - scrollDistance, 0.1),
        reason: 'Open child should scroll in lockstep with the dial button',
      );

      await tapAtAndSettle(tester, initialDialCenter);
      expect(
        find.text('ScrolledChild'),
        findsOneWidget,
        reason: 'Tapping old dial coordinates should not hit relocated button',
      );

      await tapAtAndSettle(tester, tester.getCenter(find.byType(SpeedDial)));
      expect(
        find.text('ScrolledChild'),
        findsNothing,
        reason: 'Tapping relocated dial coordinates should close the dial',
      );
    });
  });
}

class _RecordingNotchedShape extends CircularNotchedRectangle {
  const _RecordingNotchedShape({required this.onGetOuterPath});

  final void Function(Rect? guest) onGetOuterPath;

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    onGetOuterPath(guest);
    return super.getOuterPath(host, guest);
  }
}
