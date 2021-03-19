import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter Speed Dial v4';
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var speedDialOrientation = SpeedDialOrientation.Up;
  var selectedfABLocation = FloatingActionButtonLocation.endFloat;
  var items = [
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.endTop,
    FloatingActionButtonLocation.centerTop
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Speed Dial Example"),
      ),
      body: Center(
        child: ListView(shrinkWrap: true, children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SpeedDial Location",
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<FloatingActionButtonLocation>(
                    value: selectedfABLocation,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    underline: SizedBox(),
                    onChanged: (fABLocation) =>
                        setState(() => selectedfABLocation = fABLocation!),
                    selectedItemBuilder: (BuildContext context) {
                      return items.map<Widget>((item) {
                        return Text(item.toString().split(".")[1]);
                      }).toList();
                    },
                    items: items.map((item) {
                      return DropdownMenuItem<FloatingActionButtonLocation>(
                        child: Text(
                          item.toString().split(".")[1],
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
                Text("SpeedDial Location",
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<SpeedDialOrientation>(
                    value: speedDialOrientation,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    underline: SizedBox(),
                    onChanged: (sdo) {
                      setState(() {
                        speedDialOrientation = sdo!;
                        selectedfABLocation =
                            (sdo.value == "Up" || sdo.value == "Left")
                                ? FloatingActionButtonLocation.endFloat
                                : (sdo.value == "Down")
                                    ? FloatingActionButtonLocation.endTop
                                    : sdo.value == "Right"
                                        ? FloatingActionButtonLocation.startTop
                                        : selectedfABLocation;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return SpeedDialOrientation.values
                          .toList()
                          .map<Widget>((item) {
                        return Text(item.value);
                      }).toList();
                    },
                    items: SpeedDialOrientation.values.toList().map((item) {
                      return DropdownMenuItem<SpeedDialOrientation>(
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
        ]),
      ),
      floatingActionButtonLocation: selectedfABLocation,
      floatingActionButton: SpeedDial(
        /// both default to 16
        marginEnd: 18,
        marginBottom: 20,
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        /// This is ignored if animatedIcon is non null
        icon: Icons.add,
        activeIcon: Icons.close,
        // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
        /// The label of the main button.
        // label: Text("Open Speed Dial"),
        /// The active label of the main button, Defaults to label if not specified.
        // activeLabel: Text("Close Speed Dial"),
        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
        buttonSize: 56.0,
        visible: true,
        orientation: speedDialOrientation,

        /// If true user is forced to close dial manually
        /// by tapping main button and overlay is not rendered.
        closeManually: false,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: true,
        curve: Curves.bounceIn,
        // overlayColor: Colors.black,
        // overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        // useRotationAnimation: false,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        // activeForegroundColor: Colors.white,
        // activeBackgroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        // orientation: SpeedDialOrientation.Up,
        // childMarginBottom: 2,
        // childMarginTop: 2,
        children: [
          SpeedDialChild(
            child: Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            label: 'First',
            onTap: () => print("Hi"),
          ),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.blue,
            label: 'Second',
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            backgroundColor: Colors.green,
            label: 'Third',
            onTap: () => print('THIRD CHILD'),
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
        ],
      ),
    );
  }
}
