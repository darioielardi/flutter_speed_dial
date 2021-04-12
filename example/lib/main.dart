import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var theme = ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter Speed Dial Example';
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: theme,
        builder: (context, value, child) => MaterialApp(
              title: appTitle,
              home: MyHomePage(theme: theme),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.blue,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.blue[800],
              ),
              themeMode: value,
            ));
  }
}

class MyHomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> theme;
  MyHomePage({required this.theme});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.Up;
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Speed Dial Example"),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SpeedDial Location",
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<FloatingActionButtonLocation>(
                            value: selectedfABLocation,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 20,
                            underline: SizedBox(),
                            onChanged: (fABLocation) => setState(
                                () => selectedfABLocation = fABLocation!),
                            selectedItemBuilder: (BuildContext context) {
                              return items.map<Widget>((item) {
                                return Text(item.value);
                              }).toList();
                            },
                            items: items.map((item) {
                              return DropdownMenuItem<
                                  FloatingActionButtonLocation>(
                                child: Text(
                                  item.value,
                                ),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SpeedDial Direction",
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<SpeedDialDirection>(
                            value: speedDialDirection,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 20,
                            underline: SizedBox(),
                            onChanged: (sdo) {
                              setState(() {
                                speedDialDirection = sdo!;
                                selectedfABLocation = (sdo.value == "Up" &&
                                            selectedfABLocation.value
                                                .contains("Top")) ||
                                        (sdo.value == "Left" &&
                                            selectedfABLocation.value
                                                .contains("start"))
                                    ? FloatingActionButtonLocation.endDocked
                                    : sdo.value == "Down" &&
                                            !selectedfABLocation.value
                                                .contains("Top")
                                        ? FloatingActionButtonLocation.endTop
                                        : sdo.value == "Right" &&
                                                selectedfABLocation.value
                                                    .contains("end")
                                            ? FloatingActionButtonLocation
                                                .startDocked
                                            : selectedfABLocation;
                              });
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return SpeedDialDirection.values
                                  .toList()
                                  .map<Widget>((item) {
                                return Text(item.value);
                              }).toList();
                            },
                            items:
                                SpeedDialDirection.values.toList().map((item) {
                              return DropdownMenuItem<SpeedDialDirection>(
                                child: Text(
                                  item.value,
                                ),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: extend,
                      title: Text("Extend Speed Dial"),
                      onChanged: (val) {
                        setState(() {
                          extend = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: visible,
                      title: Text("Visible"),
                      onChanged: (val) {
                        setState(() {
                          visible = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: customDialRoot,
                      title: Text("Custom dialRoot"),
                      onChanged: (val) {
                        setState(() {
                          customDialRoot = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: renderOverlay,
                      title: Text("Render Overlay"),
                      onChanged: (val) {
                        setState(() {
                          renderOverlay = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: closeManually,
                      title: Text("Close Manually"),
                      onChanged: (val) {
                        setState(() {
                          closeManually = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: rmicons,
                      title: Text("Remove Icons (for children)"),
                      onChanged: (val) {
                        setState(() {
                          rmicons = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: useRAnimation,
                      title: Text("Use Rotation Animation"),
                      onChanged: (val) {
                        setState(() {
                          useRAnimation = val;
                        });
                      }),
                  SwitchListTile(
                      contentPadding: EdgeInsets.all(15),
                      value: switchLabelPosition,
                      title: Text("Switch Label Position"),
                      onChanged: (val) {
                        setState(() {
                          switchLabelPosition = val;
                          if (val) {
                            if ((selectedfABLocation.value.contains("end") ||
                                    selectedfABLocation.value
                                        .toLowerCase()
                                        .contains("top")) &&
                                speedDialDirection.value == "Up")
                              selectedfABLocation =
                                  FloatingActionButtonLocation.startDocked;
                            else if ((selectedfABLocation.value
                                        .contains("end") ||
                                    !selectedfABLocation.value
                                        .toLowerCase()
                                        .contains("top")) &&
                                speedDialDirection.value == "Down")
                              selectedfABLocation =
                                  FloatingActionButtonLocation.startTop;
                          }
                        });
                      }),
                ]),
              ),
            )),
        floatingActionButtonLocation: selectedfABLocation,
        floatingActionButton: SpeedDial(
          // animatedIcon: AnimatedIcons.menu_close,
          // animatedIconTheme: IconThemeData(size: 22.0),
          /// This is ignored if animatedIcon is non null
          // child: Text(
          //   "ih",
          //   style: TextStyle(color: Colors.grey),
          // ),
          // activeChild: Text("hi"),
          icon: Icons.add,
          activeIcon: Icons.close,
          openCloseDial: isDialOpen,
          dialRoot: customDialRoot
              ? (ctx, open, key, toggleChildren, layerLink) {
                  return CompositedTransformTarget(
                    link: layerLink,
                    child: TextButton(
                      key: key,
                      onPressed: toggleChildren,
                      child: Text("Text Button"),
                    ),
                  );
                }
              : null,
          buttonSize: customDialRoot ? 30 : 56,
          // iconTheme: IconThemeData(size: 22),

          /// The label of the main button.
          label: extend ? Text("Open") : null,

          /// The active label of the main button, Defaults to label if not specified.
          activeLabel: extend ? Text("Close") : null,

          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
          childrenButtonSize: 56.0,
          // buttonSize: 60,
          visible: visible,
          direction: speedDialDirection,
          switchLabelPosition: switchLabelPosition,

          /// If true user is forced to close dial manually
          closeManually: closeManually,

          /// If false, backgroundOverlay will not be rendered.
          renderOverlay: renderOverlay,
          curve: Curves.bounceIn,
          // overlayColor: Colors.black,
          // overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          useRotationAnimation: useRAnimation,
          tooltip: 'Open Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          // activeForegroundColor: Colors.red,
          // activeBackgroundColor: Colors.blue,
          elevation: 8.0,
          shape: CircleBorder(),
          // childMarginBottom: 2,
          // childMarginTop: 2,
          children: [
            SpeedDialChild(
              child: !rmicons ? Icon(Icons.accessibility) : null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'First',
              onTap: () => print("FIRST CHILD"),
            ),
            SpeedDialChild(
              child: !rmicons ? Icon(Icons.brush) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Second',
              onTap: () => print('SECOND CHILD'),
            ),
            SpeedDialChild(
              child: !rmicons ? Icon(Icons.margin) : null,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Show Snackbar',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(("Third Child Pressed")))),
              onLongPress: () => print('THIRD CHILD LONG PRESS'),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: selectedfABLocation ==
                    FloatingActionButtonLocation.startDocked
                ? MainAxisAlignment.end
                : selectedfABLocation == FloatingActionButtonLocation.endDocked
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(Icons.nightlight_round),
                tooltip: "Switch Theme",
                onPressed: () => {
                  widget.theme.value = widget.theme.value.index == 2
                      ? ThemeMode.light
                      : ThemeMode.dark
                },
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: isDialOpen,
                  builder: (ctx, value, _) => IconButton(
                        icon: Icon(Icons.open_in_browser),
                        tooltip: (!value ? "Open" : "Close") + " Speed Dial",
                        onPressed: () => {isDialOpen.value = !isDialOpen.value},
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

extension EnumExt on FloatingActionButtonLocation {
  /// Get Value of The SpeedDialDirection Enum like Up, Down, etc. in String format
  String get value => this.toString().split(".")[1];
}
