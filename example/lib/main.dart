import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), title: 'Flutter Speed Dial Examples'));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  ScrollController _scrollController;
  bool _dialVisible = true;

  initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        _setFabVisible(_scrollController.position.userScrollDirection == ScrollDirection.forward);
      });
  }

  _setFabVisible(bool value) {
    setState(() {
      _dialVisible = value;
    });
  }

  _renderBody() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: 30,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item $i')),
    );
  }

  _renderSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: _dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => print('FIRST CHILD'),
          label: 'First',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('SECOND CHILD'),
          label: 'Second',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          label: 'Third',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Speed Dial')),
      body: _renderBody(),
      floatingActionButton: _renderSpeedDial(),
    );
  }
}
