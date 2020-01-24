import 'package:flutter/material.dart';

import 'animated_child.dart';
import 'animated_floating_button.dart';
import 'background_overlay.dart';
import 'speed_dial_child.dart';

/// Builds the Speed Dial
class SpeedDial extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<SpeedDialChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  final String tooltip;
  final String heroTag;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double buttonSize;
  final ShapeBorder shape;

  final double marginRight;
  final double marginBottom;

  /// The color of the background overlay.
  final Color overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData animatedIconTheme;

  /// The child of the main button, ignored if [animatedIcon] is non [null].
  final Widget child;

  /// Executed when the dial is opened.
  final VoidCallback onOpen;

  /// Executed when the dial is closed.
  final VoidCallback onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback onPress;

  /// If true user is forced to close dial manually by tapping main button. WARNING: If true, overlay is not rendered.
  final bool closeManually;

  /// The speed of the animation
  final int animationSpeed;

  SpeedDial({
    this.children = const [],
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.buttonSize,
    this.overlayOpacity = 0.8,
    this.overlayColor = Colors.white,
    this.tooltip,
    this.heroTag,
    this.animatedIcon,
    this.animatedIconTheme,
    this.child,
    this.marginBottom = 16,
    this.marginRight = 16,
    this.onOpen,
    this.onClose,
    this.closeManually = false,
    this.shape = const CircleBorder(),
    this.curve = Curves.linear,
    this.onPress,
    this.animationSpeed = 150,
  });

  @override
  _SpeedDialState createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _calculateMainControllerDuration(),
      vsync: this,
    );
  }

  Duration _calculateMainControllerDuration() => Duration(
      milliseconds: widget.animationSpeed +
          widget.children.length * (widget.animationSpeed / 5).round());

  @override
  void dispose() {
    _controller.dispose();
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

    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    var newValue = !_open;
    setState(() {
      _open = newValue;
    });
    if (newValue && widget.onOpen != null) widget.onOpen();
    _performAnimation();
    if (!newValue && widget.onClose != null) widget.onClose();
  }

  List<Widget> _getChildrenList() {
    final singleChildrenTween = 1.0 / widget.children.length;

    return widget.children
        .map((SpeedDialChild child) {
          int index = widget.children.indexOf(child);

          var childAnimation =
              Tween(begin: 0.0, end: widget.buttonSize ?? 56.0).animate(
            CurvedAnimation(
              parent: this._controller,
              curve: Interval(0, singleChildrenTween * (index + 1)),
            ),
          );

          return AnimatedChild(
            animation: childAnimation,
            index: index,
            visible: _open,
            backgroundColor: child.backgroundColor,
            foregroundColor: child.foregroundColor,
            elevation: child.elevation,
            child: child.child,
            label: child.label,
            buttonSize: widget.buttonSize,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            onTap: child.onTap,
            toggleChildren: () {
              if (!widget.closeManually) _toggleChildren();
            },
            shape: child.shape,
            heroTag: widget.heroTag != null
                ? '${widget.heroTag}-child-$index'
                : null,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _renderOverlay() {
    return Positioned(
      right: -16.0,
      bottom: -16.0,
      top: _open ? 0.0 : null,
      left: _open ? 0.0 : null,
      child: GestureDetector(
        onTap: _toggleChildren,
        child: BackgroundOverlay(
          animation: _controller,
          color: widget.overlayColor,
          opacity: widget.overlayOpacity,
        ),
      ),
    );
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? AnimatedIcon(
            icon: widget.animatedIcon,
            progress: _controller,
            color: widget.animatedIconTheme?.color,
            size: widget.animatedIconTheme?.size,
          )
        : widget.child;

    var fabChildren = _getChildrenList();

    var animatedFloatingButton = AnimatedFloatingButton(
      visible: widget.visible,
      tooltip: widget.tooltip,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      size: widget.buttonSize,
      onLongPress: _toggleChildren,
      callback:
          (_open || widget.onPress == null) ? _toggleChildren : widget.onPress,
      child: child,
      heroTag: widget.heroTag,
      shape: widget.shape,
      curve: widget.curve,
    );

    return Positioned(
      bottom: widget.marginBottom - 16,
      right: widget.marginRight - 16,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.from(fabChildren)
            ..add(
              Container(
                margin: EdgeInsets.only(top: 8.0, right: 0.0),
                child: animatedFloatingButton,
              ),
            ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      if (!widget.closeManually) _renderOverlay(),
      _renderButton(),
    ];

    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: children,
    );
  }
}
