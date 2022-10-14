import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var theme = ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Flutter Speed Dial Example';
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
                primaryColor: Colors.lightBlue[900],
              ),
              themeMode: value,
            ));
  }
}

class MyHomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> theme;
  const MyHomePage({Key? key, required this.theme}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
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
          title: const Text("Flutter Speed Dial Example"),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SpeedDial Location",
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<FloatingActionButtonLocation>(
                              value: selectedfABLocation,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              underline: const SizedBox(),
                              onChanged: (fABLocation) => setState(
                                  () => selectedfABLocation = fABLocation!),
                              selectedItemBuilder: (BuildContext context) {
                                return items.map<Widget>((item) {
                                  return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Text(item.value)));
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SpeedDial Direction",
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<SpeedDialDirection>(
                              value: speedDialDirection,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              underline: const SizedBox(),
                              onChanged: (sdo) {
                                setState(() {
                                  speedDialDirection = sdo!;
                                  selectedfABLocation = (sdo.isUp &&
                                              selectedfABLocation.value
                                                  .contains("Top")) ||
                                          (sdo.isLeft &&
                                              selectedfABLocation.value
                                                  .contains("start"))
                                      ? FloatingActionButtonLocation.endDocked
                                      : sdo.isDown &&
                                              !selectedfABLocation.value
                                                  .contains("Top")
                                          ? FloatingActionButtonLocation.endTop
                                          : sdo.isRight &&
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
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            describeEnum(item).toUpperCase())),
                                  );
                                }).toList();
                              },
                              items: SpeedDialDirection.values
                                  .toList()
                                  .map((item) {
                                return DropdownMenuItem<SpeedDialDirection>(
                                  child: Text(describeEnum(item).toUpperCase()),
                                  value: item,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!customDialRoot)
                      SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          value: extend,
                          title: const Text("Extend Speed Dial"),
                          onChanged: (val) {
                            setState(() {
                              extend = val;
                            });
                          }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: visible,
                        title: const Text("Visible"),
                        onChanged: (val) {
                          setState(() {
                            visible = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: mini,
                        title: const Text("Mini"),
                        onChanged: (val) {
                          setState(() {
                            mini = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: customDialRoot,
                        title: const Text("Custom dialRoot"),
                        onChanged: (val) {
                          setState(() {
                            customDialRoot = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: renderOverlay,
                        title: const Text("Render Overlay"),
                        onChanged: (val) {
                          setState(() {
                            renderOverlay = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: closeManually,
                        title: const Text("Close Manually"),
                        onChanged: (val) {
                          setState(() {
                            closeManually = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: rmicons,
                        title: const Text("Remove Icons (for children)"),
                        onChanged: (val) {
                          setState(() {
                            rmicons = val;
                          });
                        }),
                    if (!customDialRoot)
                      SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          value: useRAnimation,
                          title: const Text("Use Rotation Animation"),
                          onChanged: (val) {
                            setState(() {
                              useRAnimation = val;
                            });
                          }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: switchLabelPosition,
                        title: const Text("Switch Label Position"),
                        onChanged: (val) {
                          setState(() {
                            switchLabelPosition = val;
                            if (val) {
                              if ((selectedfABLocation.value.contains("end") ||
                                      selectedfABLocation.value
                                          .toLowerCase()
                                          .contains("top")) &&
                                  speedDialDirection.isUp) {
                                selectedfABLocation =
                                    FloatingActionButtonLocation.startDocked;
                              } else if ((selectedfABLocation.value
                                          .contains("end") ||
                                      !selectedfABLocation.value
                                          .toLowerCase()
                                          .contains("top")) &&
                                  speedDialDirection.isDown) {
                                selectedfABLocation =
                                    FloatingActionButtonLocation.startTop;
                              }
                            }
                          });
                        }),
                    const Text("Button Size"),
                    Slider(
                      value: buttonSize.width,
                      min: 50,
                      max: 500,
                      label: "Button Size",
                      onChanged: (val) {
                        setState(() {
                          buttonSize = Size(val, val);
                        });
                      },
                    ),
                    const Text("Children Button Size"),
                    Slider(
                      value: childrenButtonSize.height,
                      min: 50,
                      max: 500,
                      onChanged: (val) {
                        setState(() {
                          childrenButtonSize = Size(val, val);
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Navigation",
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MyHomePage(theme: widget.theme),
                                  ),
                                );
                              },
                              child: const Text("Push Duplicate Page")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        floatingActionButtonLocation: selectedfABLocation,
        floatingActionButton: SpeedDial(
          // animatedIcon: AnimatedIcons.menu_close,
          // animatedIconTheme: IconThemeData(size: 22.0),
          // / This is ignored if animatedIcon is non null
          // child: Text("open"),
          // activeChild: Text("close"),
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          mini: mini,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          dialRoot: customDialRoot
              ? (ctx, open, toggleChildren) {
                  return ElevatedButton(
                    onPressed: toggleChildren,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 18),
                    ),
                    child: const Text(
                      "Custom Dial Root",
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }
              : null,
          buttonSize:
              buttonSize, // it's the SpeedDial size which defaults to 56 itself
          // iconTheme: IconThemeData(size: 22),
          label: extend
              ? const Text("Open")
              : null, // The label of the main button.
          /// The active label of the main button, Defaults to label if not specified.
          activeLabel: extend ? const Text("Close") : null,

          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the SpeedDial childrens size
          childrenButtonSize: childrenButtonSize,
          visible: visible,
          direction: speedDialDirection,
          switchLabelPosition: switchLabelPosition,

          /// If true user is forced to close dial manually
          closeManually: closeManually,

          /// If false, backgroundOverlay will not be rendered.
          renderOverlay: renderOverlay,
          // overlayColor: Colors.black,
          // overlayOpacity: 0.5,
          onOpen: () => debugPrint('OPENING DIAL'),
          onClose: () => debugPrint('DIAL CLOSED'),
          useRotationAnimation: useRAnimation,
          tooltip: 'Open Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          // activeForegroundColor: Colors.red,
          // activeBackgroundColor: Colors.blue,
          elevation: 8.0,
          animationCurve: Curves.elasticInOut,
          isOpenOnStart: false,
          shape: customDialRoot
              ? const RoundedRectangleBorder()
              : const StadiumBorder(),
          // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.accessibility) : null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'First',
              onTap: () => setState(() => rmicons = !rmicons),
              onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.brush) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Second',
              onTap: () => debugPrint('SECOND CHILD'),
            ),
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.margin) : null,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Show Snackbar',
              visible: true,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(("Third Child Pressed")))),
              onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
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
                icon: const Icon(Icons.nightlight_round),
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
                        icon: const Icon(Icons.open_in_browser),
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
  String get value => toString().split(".")[1];
}
