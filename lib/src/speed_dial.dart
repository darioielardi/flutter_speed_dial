import 'dart:math';

import 'package:flutter/material.dart';

import 'animated_child.dart';
import 'animated_floating_button.dart';
import 'background_overlay.dart';
import 'speed_dial_child.dart';
import 'speed_dial_orientation.dart';

/// Builds the Speed Dial
// ignore: must_be_immutable
class SpeedDial extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<SpeedDialChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  final String? tooltip;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? activeBackgroundColor;
  final Color? activeForegroundColor;
  final double elevation;
  final double buttonSize;
  final ShapeBorder shape;
  final Gradient? gradient;
  final BoxShape gradientBoxShape;

  final double marginEnd;
  final double marginBottom;

  /// The color of the background overlay.
  final Color? overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData? animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData? animatedIconTheme;

  /// The icon of the main button, ignored if [animatedIcon] is non [null].
  final IconData? icon;

  /// The active icon of the main button, Defaults to icon if not specified, ignored if [animatedIcon] is non [null].
  final IconData? activeIcon;

  /// If true then rotation animation will be used when animating b/w activeIcon and icon.
  final bool useRotationAnimation;

  /// The theme for the icon generally includes color and size.
  final IconThemeData? iconTheme;

  /// The label of the main button.
  final Widget? label;

  /// The active label of the main button, Defaults to label if not specified.
  final Widget? activeLabel;

  /// Transition Builder between label and activeLabel, defaults to FadeTransition.
  final Widget Function(Widget, Animation<double>)? labelTransitionBuilder;

  /// Executed when the dial is opened.
  final VoidCallback? onOpen;

  /// Executed when the dial is closed.
  final VoidCallback? onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback? onPress;

  /// If true user is forced to close dial manually by tapping main button. WARNING: If true, overlay is not rendered.
  final bool closeManually;

  /// If true overlay is rendered, no matter if closeManually is true or false.
  final bool renderOverlay;

  /// Open or close the dial via a notification
  final ValueNotifier<bool>? openCloseDial;

  /// The speed of the animation in milliseconds
  final int animationSpeed;

  /// The bottom margin of each child
  final double childMarginBottom;

  /// The top margin of each child
  final double childMarginTop;

  /// The orientation of the children. Default is [SpeedDialOrientation.Up]
  final SpeedDialOrientation orientation;

  /// If Provided then it will replace the default Floating Action Button
  /// and will show the Widget Specified as dialRoot instead, it will also
  /// ignore backgroundColor, foregroundColor or any other property
  /// that was specific to FAB before like onPress, you will have to provide
  /// it again to your dialRoot button.
  final Widget? dialRoot;

  /// If Provided then it will use Inkwell
  /// for onLongPress instead of GestureDetector on Top of Root Widget
  final bool useInkWell;

  /// This is the child of the FAB, if specified it will ignore icon, activeIcon.
  final Widget? child;

  /// This is the active child of the FAB, if specified it will animate b/w this
  /// and the child.
  final Widget? activeChild;

  SpeedDial({
    Key? key,
    this.children = const [],
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.gradient,
    this.gradientBoxShape = BoxShape.rectangle,
    this.elevation = 6.0,
    this.buttonSize = 56.0,
    this.dialRoot,
    this.useInkWell = false,
    this.overlayOpacity = 0.8,
    this.overlayColor,
    this.tooltip,
    this.heroTag,
    this.animatedIcon,
    this.animatedIconTheme,
    this.icon,
    this.activeIcon,
    this.child,
    this.activeChild,
    this.useRotationAnimation = true,
    this.iconTheme,
    this.label,
    this.activeLabel,
    this.labelTransitionBuilder,
    this.marginBottom = 16,
    this.marginEnd = 16,
    this.onOpen,
    this.onClose,
    this.orientation = SpeedDialOrientation.Up,
    this.closeManually = false,
    this.renderOverlay = false,
    this.shape = const CircleBorder(),
    this.curve = Curves.linear,
    this.onPress,
    this.animationSpeed = 150,
    this.openCloseDial,
    this.childMarginBottom = 0,
    this.childMarginTop = 0,
  }) : super(key: key);

  @override
  _SpeedDialState createState() => _SpeedDialState();

  late bool _dark;
}

class _SpeedDialState extends State<SpeedDial> with TickerProviderStateMixin {
  late AnimationController _controller;

  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _calculateMainControllerDuration(),
      vsync: this,
    );
    widget.openCloseDial?.addListener(() {
      final show = widget.openCloseDial?.value;
      if (!mounted) return;
      if (_open != show) {
        _toggleChildren();
      }
    });
  }

  Duration _calculateMainControllerDuration() => Duration(
      milliseconds: widget.animationSpeed +
          widget.children.length * (widget.animationSpeed / 5).round());

  @override
  void dispose() {
    _controller.dispose();
    widget.openCloseDial?.removeListener(() {});
    super.dispose();
  }

  void _performAnimation() {
    if (!mounted) return;
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(SpeedDial oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _controller.duration = _calculateMainControllerDuration();
    }

    widget.openCloseDial?.removeListener(() {});
    widget.openCloseDial?.addListener(() {
      final show = widget.openCloseDial?.value;
      if (!mounted) return;
      if (_open != show) {
        _toggleChildren();
      }
    });

    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    if (widget.children.length > 0) {
      var newValue = !_open;
      setState(() {
        _open = newValue;
      });
      if (widget.openCloseDial != null) widget.openCloseDial?.value = newValue;
      if (newValue && widget.onOpen != null) widget.onOpen?.call();
      _performAnimation();
      if (!newValue && widget.onClose != null) widget.onClose?.call();
    } else if (widget.onOpen != null) widget.onOpen?.call();
  }

  List<Widget> _getChildrenList() {
    final singleChildrenTween = 1.0 / widget.children.length;

    return widget.children
        .map((SpeedDialChild child) {
          int index = widget.children.indexOf(child);

          var childAnimation =
              Tween(begin: 0.0, end: widget.buttonSize).animate(
            CurvedAnimation(
              parent: this._controller,
              curve: Interval(0, singleChildrenTween * (index + 1)),
            ),
          );

          return AnimatedChild(
            animation: childAnimation,
            index: index,
            key: child.key,
            visible: _open,
            useInkWell: widget.useInkWell,
            dark: widget._dark,
            backgroundColor: child.backgroundColor,
            foregroundColor: child.foregroundColor,
            elevation: child.elevation,
            buttonSize: widget.buttonSize,
            child: child.child,
            label: child.label,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            onTap: child.onTap,
            onLongPress: child.onLongPress,
            toggleChildren: () {
              if (!widget.closeManually) _toggleChildren();
            },
            shape: child.shape,
            heroTag: widget.heroTag != null
                ? '${widget.heroTag}-child-$index'
                : null,
            childMarginBottom: widget.childMarginBottom,
            childMarginTop: widget.childMarginTop,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _renderOverlay() {
    return PositionedDirectional(
      end: -16.0,
      bottom: -16.0,
      top: _open ? 0.0 : null,
      start: _open ? 0.0 : null,
      child: GestureDetector(
        onTap: _toggleChildren,
        child: BackgroundOverlay(
          animation: _controller,
          color: widget.overlayColor ??
              (widget._dark ? Colors.grey[900] : Colors.white),
          opacity: widget.overlayOpacity,
        ),
      ),
    );
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? Container(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: Center(
              child: AnimatedIcon(
                icon: widget.animatedIcon!,
                progress: _controller,
                color: widget.animatedIconTheme?.color,
                size: widget.animatedIconTheme?.size,
              ),
            ),
            decoration: BoxDecoration(
              shape: widget.gradientBoxShape,
              gradient: widget.gradient,
            ),
          )
        : AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? _widget) => Transform(
              transform: Matrix4.rotationZ(_controller.value * 0.5 * pi),
              alignment: FractionalOffset.center,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: widget.animationSpeed),
                  child: (widget.activeChild == null &&
                          widget.child != null &&
                          _controller.value < 0.5)
                      ? widget.child
                      : (widget.activeChild != null && _controller.value > 0.5)
                          ? widget.activeChild
                          : (widget.activeIcon == null ||
                                  _controller.value < 0.5)
                              ? Container(
                                  width: widget.buttonSize,
                                  height: widget.buttonSize,
                                  child: Center(
                                    child: Icon(
                                      widget.icon,
                                      key: ValueKey<int>(0),
                                      color: widget.iconTheme?.color,
                                      size: widget.iconTheme?.size,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    shape: widget.gradientBoxShape,
                                    gradient: widget.gradient,
                                  ),
                                )
                              : Container(
                                  width: widget.buttonSize,
                                  height: widget.buttonSize,
                                  child: Center(
                                    child: Icon(
                                      widget.activeIcon,
                                      key: ValueKey<int>(1),
                                      color: widget.iconTheme?.color,
                                      size: widget.iconTheme?.size,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    shape: widget.gradientBoxShape,
                                    gradient: widget.gradient,
                                  ),
                                )),
            ),
          );

    var label = AnimatedSwitcher(
      duration: Duration(milliseconds: widget.animationSpeed),
      transitionBuilder: widget.labelTransitionBuilder ??
          (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
      child: (!_open || widget.activeLabel == null)
          ? widget.label
          : widget.activeLabel,
    );

    var fabChildren = _getChildrenList();

    final backgroundColor = widget.backgroundColor ??
        (widget._dark ? Colors.grey[800] : Colors.grey[50]);
    final foregroundColor =
        widget.foregroundColor ?? (widget._dark ? Colors.white : Colors.black);

    final backgroundColorTween = ColorTween(
        begin: backgroundColor,
        end: widget.activeBackgroundColor ?? backgroundColor);
    final foregroundColorTween = ColorTween(
        begin: foregroundColor,
        end: widget.activeForegroundColor ?? foregroundColor);

    var animatedFloatingButton = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => AnimatedFloatingButton(
        key: widget.key,
        visible: widget.visible,
        useInkWell: widget.useInkWell,
        tooltip: widget.tooltip,
        dialRoot: widget.dialRoot,
        backgroundColor: backgroundColorTween.lerp(_controller.value),
        foregroundColor: foregroundColorTween.lerp(_controller.value),
        elevation: widget.elevation,
        onLongPress: _toggleChildren,
        callback: (_open || widget.onPress == null)
            ? _toggleChildren
            : widget.onPress,
        size: widget.buttonSize,
        label: widget.label != null ? label : null,
        child: child,
        heroTag: widget.heroTag,
        shape: widget.shape,
        curve: widget.curve,
      ),
    );

    switch (widget.orientation) {
      case SpeedDialOrientation.Down:
        return PositionedDirectional(
          top: MediaQuery.of(context).size.height -
              widget.buttonSize -
              (widget.marginBottom - 16),
          end: widget.marginEnd - 16,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.from(fabChildren.reversed)
                ..insert(
                    0,
                    Container(
                      margin: EdgeInsetsDirectional.only(bottom: 8.0),
                      child: animatedFloatingButton,
                    )),
            ),
          ),
        );
      case SpeedDialOrientation.Up:
      default:
        return PositionedDirectional(
          bottom: widget.marginBottom - 16,
          end: widget.marginEnd - 16,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.from(fabChildren)
                ..add(Container(
                  margin: EdgeInsetsDirectional.only(top: 8.0),
                  child: animatedFloatingButton,
                )),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final children = [
      if ((!widget.closeManually || widget.renderOverlay) &&
          widget.children.length > 0)
        _renderOverlay(),
      _renderButton(),
    ];

    var stack = Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: children,
    );

    return stack;
  }
}
