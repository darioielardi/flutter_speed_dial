# Flutter Speed Dial

Flutter package to render a [Material Design Speed Dial](https://material.io/design/components/buttons-floating-action-button.html#types-of-transitions).

![Flutter Speed Dial](https://media.giphy.com/media/ef4BpmetvvH9BdQC9t/giphy.gif)

## Usage

The widget takes place in the *floatingActionButton* parameter of the *Scaffold* widget.
It's not possible to set its position with the *Scaffold.floatingActionButtonLocation* parameter though.
The use with the *Scaffold.bottomNavigationBar* is possible but the floating button will take place above the bar.

**Labels**

Every child button can have a label, which can be customized providing a *labelStyle*. If the *label* parameter is not provided the label will be not rendered.

**Animated Icon**

The main floating action button child can set with the *child* parameter, however to make easier to use an *AnimatedIcon* there are two specific parameters:
- *animatedIcon* takes an *AnimatedIconData* widget
- *animatedIconTheme* takes its theme

The package will handle the animation by itself.

**Hide on Scroll**

Another possibility is to make the button hide on scroll with a curve animation, with a *visible* parameter to set dynamically based on the scroll direction. See the [example project](example/lib/main.dart) for more info.

**Example Usage:**
```
Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: _dialVisible,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: 'First',
              labelStyle: TextTheme(fontSize: 18.0),
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(Icons.brush),
              backgroundColor: Colors.blue,
              label: 'Second',
              labelStyle: TextTheme(fontSize: 18.0),
              onTap: () => print('SECOND CHILD'),
            ),
            SpeedDialChild(
              child: Icon(Icons.keyboard_voice),
              backgroundColor: Colors.green,
              label: 'Third',
              labelStyle: TextTheme(fontSize: 18.0),
              onTap: () => print('THIRD CHILD'),
            ),
          ],
        ),
    );
}
```