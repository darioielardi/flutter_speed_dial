import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatelessWidget {
  final bool visible;
  final VoidCallback callback;
  final VoidCallback onLongPress;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final String tooltip;
  final String heroTag;
  final double elevation;
  final ShapeBorder shape;
  final Curve curve;

  AnimatedFloatingButton({
    this.visible = true,
    this.callback,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
    this.elevation = 6.0,
    this.shape = const CircleBorder(),
    this.curve = Curves.linear,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    var margin = visible ? 0.0 : 28.0;

    return Container(
      constraints: BoxConstraints(
        minHeight: 0.0,
        minWidth: 0.0,
      ),
      width: 56.0,
      height: 56.0,
      child: AnimatedContainer(
          curve: curve,
          margin: EdgeInsets.all(margin),
          duration: Duration(milliseconds: 150),
          width: visible ? 56.0 : 0.0,
          height: visible ? 56.0 : 0.0,
          child: GestureDetector(
            onLongPress: onLongPress,
            child: FloatingActionButton(
              child: visible ? child : null,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              onPressed: callback,
              tooltip: tooltip,
              heroTag: heroTag,
              elevation: elevation,
              highlightElevation: elevation,
              shape: shape,
            ),
          ),
      ),
    );
  }
}
