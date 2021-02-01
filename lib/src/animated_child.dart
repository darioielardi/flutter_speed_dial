import 'package:flutter/material.dart';

class AnimatedChild extends AnimatedWidget {
  final int index;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double buttonSize;
  final Widget child;

  final String label;
  final TextStyle labelStyle;
  final Color labelBackgroundColor;
  final Widget labelWidget;

  final bool visible;
  final bool dark;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback toggleChildren;
  final ShapeBorder shape;
  final String heroTag;

  final double childMarginBottom;
  final double childMarginTop;
  final double _paddingPercent = 0.125;

  AnimatedChild({
    Key key,
    Animation<double> animation,
    this.index,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.buttonSize = 56.0,
    this.child,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.visible = false,
    this.dark,
    this.onTap,
    this.onLongPress,
    this.toggleChildren,
    this.shape,
    this.heroTag,
    this.childMarginBottom,
    this.childMarginTop,
  }) : super(key: key, listenable: animation);

  Widget buildLabel() {
    final Animation<double> animation = listenable;

    if (!((label != null || labelWidget != null) && visible && animation.value == buttonSize)) {
      return Container();
    }

    if (labelWidget != null) {
      return GestureDetector(
        onTap: _performAction,
        onLongPress: _performLongAction,
        child: labelWidget,
      );
    }

    return GestureDetector(
      onTap: _performAction,
      onLongPress: _performLongAction,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        margin: EdgeInsetsDirectional.fromSTEB(0, childMarginTop, 18.0, childMarginBottom),
        decoration: BoxDecoration(
          color: labelBackgroundColor ?? (dark ? Colors.grey[800] : Colors.grey[50]),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          boxShadow: [
            BoxShadow(
              color: dark ? Colors.grey[900].withOpacity(0.7) : Colors.grey.withOpacity(0.7),
              offset: Offset(0.8, 0.8),
              blurRadius: 2.4,
            )
          ],
        ),
        child: Text(label, style: labelStyle),
      ),
    );
  }

  void _performAction() {
    print('performAction');
    if (onTap != null) onTap();
    toggleChildren();
  }

  void _performLongAction() {
    print('performLongAction');
    if (onLongPress != null) onLongPress();
    toggleChildren();
  }

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    final Widget buttonChild = animation.value > 50.0
        ? Container(
            width: animation.value,
            height: animation.value,
            child: Center(child: child) ?? Container(),
          )
        : Container(
            width: 0.0,
            height: 0.0,
          );

    FloatingActionButton button = FloatingActionButton(
      heroTag: heroTag,
      onPressed: _performAction,
      backgroundColor: backgroundColor ?? (dark ? Colors.grey[800] : Colors.grey[50]),
      foregroundColor: foregroundColor ?? (dark ? Colors.white : Colors.black),
      elevation: elevation ?? 6.0,
      child: buttonChild,
      shape: shape,
    );

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          buildLabel(),
          Container(
            width: buttonSize,
            height: animation.value,
            padding: EdgeInsets.only(bottom: buttonSize - animation.value),
            child: Container(
              height: buttonSize,
              width: animation.value,
              padding: EdgeInsets.only(
                left: _paddingPercent * buttonSize, // This will give relative padding size
                right: _paddingPercent * buttonSize,
              ),
              child: (onLongPress == null) ? button : GestureDetector(
                onLongPress: _performLongAction,
                child: button,
              ),
            ),
          )
        ],
      ),
    );
  }
}
