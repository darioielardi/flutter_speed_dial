# Flutter Speed Dial - Ultimate Edition

Flutter package to render a [Material Design Speed Dial](https://material.io/design/components/buttons-floating-action-button.html#types-of-transitions).

![Flutter Speed Dial](https://user-images.githubusercontent.com/41370460/113670683-0de04700-96d3-11eb-8029-aeadf1797b60.gif)

## Usage

The SpeedDial widget is built to be placed in the `Scaffold.floatingActionButton` argument, replacing the `FloatingActionButton` widget.
You can set its position using `Scaffold.floatingActionButtonLocation` argument.
It can also be used with `Scaffold.bottomNavigationBar` and `Snackbar`.

**Nullsafety** is availabile from version **3.0.5** *( It is also backward compatible,  meaning you can use it with not null safe code too )*

**Labels**

SpeedDial and its child all have `label`. SpeedDial takes any Widget as `label`. It also have `activeLabel` property by which you can specify the label which is shown when SpeedDial is open. It also comes with its labelTransitionBuilder which defaults to fade transition.

Also Every child button have `label` property which accepts `String` which can be styled by using `labelStyle`. If you want to specify a widget then you can use labelWidget.
If the `label` parameter is not provided the label will be not rendered.

**Animated Icon**

The main floating action button child can set with the `icon` parameter, you can animate that icon by setting `activeIcon` paramater, It have four relatable paramters:

- `icon` & `activeIcon` takes an `IconData` widget
- `iconTheme` takes its theme which includes color and size


 however if you want to use an Animated icon by specifying `AnimatedIconData` then you can use `AnimatedIcon`, it has two specific parameters:

- `animatedIcon` takes an `AnimatedIconData` widget
- `animatedIconTheme` takes its theme

The package will handle the animation by itself.

**Hide on Scroll**

Another possibility is to make the button hide on scroll with a curve animation, with a `visible` parameter to set dynamically based on the scroll direction. See the [example project](example/lib/main.dart) for more info.

### Close on WillPop

Although it doesn't magically closes when you press back button, but requires a easier setup to enable this functionality, here are the steps that you need to do to enable that:

1. Add a value Notifier inside your widgets build context where your speedDial is placed like below.
```dart
ValueNotifier<bool> isDialOpen = ValueNotifier(false);
```
2. Then you need to add a property to your speedDial known as openCloseManually like below.
```dart
  openCloseDial: isDialOpen,
```
3. Add a will Pop in your body or anywhere where you want and then simply add the following line in its onWillPop element.
```dart
WillPopScope(
  onWillPop: () async {
    if (isDialOpen.value) {
      isDialOpen.value = false;
      return false;
    }
    ...other checks here
  }
  child: ...your child goes here
)
```

[**Classes API Docs**](https://pub.dev/documentation/flutter_speed_dial/latest/flutter_speed_dial/flutter_speed_dial-library.html)

### Example Usage

See [Example Code](example/lib/main.dart) for more info.

## Issues & Feedback

Please file an [issue](https://github.com/darioielardi/flutter_speed_dial/issues) to send feedback or report a bug,  
If you want to ask a question or suggest an idea then you can [open an discussion](https://github.com/darioielardi/flutter_speed_dial/discussions).  
Thank you!

## Contributing

Every pull request is welcome.
