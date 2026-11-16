import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> pumpSpeedDialScaffold(
  WidgetTester tester, {
  Key? scaffoldKey,
  Widget? body,
  SpeedDial? speedDial,
  FloatingActionButtonLocation? location,
  Widget? bottomNavigationBar,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        body: body,
        floatingActionButtonLocation: location,
        floatingActionButton: speedDial,
        bottomNavigationBar: bottomNavigationBar,
      ),
    ),
  );
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> tapAtAndSettle(WidgetTester tester, Offset location) async {
  await tester.tapAt(location);
  await tester.pumpAndSettle();
}

Future<void> tapOutsideAndExpectClosed(
  WidgetTester tester, {
  required String hiddenText,
}) async {
  await tapAtAndSettle(tester, const Offset(10, 10));
  expect(find.text(hiddenText), findsNothing);
}
