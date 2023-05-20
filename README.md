<h2 align="center">Flutter Speed Dial</h1>

<p align="center">
Flutter package to render a <a href="https://material.io/design/components/buttons-floating-action-button.html#types-of-transitions">Material Design Speed Dial</a>.
</p>


## Support the development

To sustain the development of this library we need someone who can help this library either through code or by donating it. Donation will help us to live up in the world of unmaintained open source packages and to dedicate more time in improving this to live up to the mark. We will also add the name of the contributors or the donaters in the README section.

To donate directly you can use below link, don't forget to leave a message there:

<a href="https://www.buymeacoffee.com/prateeksunal" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

Or become a Github sponser by clicking on the Sponser button in this repository.

<p align="center"><a href="https://github.com/darioielardi/flutter_speed_dial/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/darioielardi/flutter_speed_dial"/></a> <a href="LICENSE"><img alt="License" src="https://img.shields.io/github/license/darioielardi/flutter_speed_dial?color=blue"/></a> <a href="https://pub.dev/documentation/flutter_speed_dial/latest/flutter_speed_dial/flutter_speed_dial-library.html"><img alt="Classic API Docs" src="https://img.shields.io/badge/Classic Docs-informational"/></a> <a href="#usage"><img alt="Usage" src="https://img.shields.io/badge/Usage-blue"/></a></p>

<p align="center">
<img src="https://user-images.githubusercontent.com/41370460/113670683-0de04700-96d3-11eb-8029-aeadf1797b60.gif" height="460">
</p>

### Usage

The SpeedDial widget is built to be placed in the `Scaffold.floatingActionButton` argument, replacing the `FloatingActionButton` widget.
You can set its position using `Scaffold.floatingActionButtonLocation` argument.
It can also be used with `Scaffold.bottomNavigationBar` and `Snackbar`.

**Null safety** is available from version **3.0.5** *( It is also backward compatible,  meaning you can use it with non null safe code too )*

#### Labels

SpeedDial can take any Widget as `label` *SpeedDial will use Extended FloatingActionButton property if label is specified*. It also have `activeLabel` property by which you can specify the label which is shown when SpeedDial is open. It also comes with its labelTransitionBuilder which defaults to fade transition.

Also Every child's button have `label` property which accepts `String` which can be styled by using `labelStyle`. If you want to specify a widget then you can use labelWidget.  
If the `label` parameter is not provided, then the label will be not rendered.

#### Types of child for SpeedDial *(Ordered by their priority)*
<details>
 <summary>
  <b>Animated Icon</b> using <code>animatedIcon</code> property
 </summary>
SpeedDial's AnimatedIcon has two specific parameters:

- `animatedIcon` takes an `AnimatedIconData` widget
- `animatedIconTheme` takes `IconThemeData`
</details>
<details>
 <summary>
  <b>Widget</b> using <code>child</code> & <code>activeChild</code> property
 </summary>
SpeedDial's Widget has two specific parameters:

- `child` takes a widget and is the default placeholder if dial is not open.
- `activeChild` takes a widget and is the child's Widget which is used when dial is open, not required.
</details>
<details>
 <summary>
  <b>IconData</b> using <code>icon</code> & <code>activeIcon</code> property
 </summary>
SpeedDial's IconData has three specific parameters:

- `icon` takes a `IconData` and is the default placeholder if dial is not open.
- `activeIcon` takes a `IconData` and is the child's IconData which is used when dial is open, not required.
- `iconTheme` takes its `IconThemeData` which includes color and size.
</details>

The package will handle the animation by itself.

#### Handle spacing

There are various properties for SpeedDial by which you can adjust the spacing:

1. `spacing` - This parameter handles the space b/w speed dial and its children.  

2. `spaceBetweenChildren` - As the name suggests, this is used to adjust the space b/w every child element  

3. `childPadding` - This will adjust the padding of children speed dial button, this will help you to control the size of the children button more effectively.  

4. `childMargin` - This will help you to adjust the margin b/w children speed dial button and its label.  

#### Close on WillPop

Closes automatically on back button press, if dial is open.
If you don't want this behaviour then simply change the value of `closeDialOnPop` to false.

#### How to use `openCloseDial` property:

1. Create a value notifier named `isDialOpen`:
```dart
ValueNotifier<bool> isDialOpen = ValueNotifier(false);
```
2. Then set `openCloseDial` to `isDialOpen` in your `SpeedDial`:
```dart
SpeedDial(
  ...
  openCloseDial: isDialOpen,
  ...
)
```
3. Now you can change the state of dial open:
```dart
isDialOpen.value = false;
```

#### Example Usage

See [Example Code](example/lib/main.dart) for more info.

### Issues & Feedback

Please file an [issue](https://github.com/darioielardi/flutter_speed_dial/issues) to send feedback or report a bug,  
If you want to ask a question or suggest an idea then you can [open an discussion](https://github.com/darioielardi/flutter_speed_dial/discussions).  
Thank you!

### Contributing

Every pull request is welcome.
