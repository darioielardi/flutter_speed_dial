import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatelessWidget {
  final bool visible;
  final VoidCallback? callback;
  final VoidCallback? onLongPress;
  final Widget? label;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final String? heroTag;
  final double elevation;
  final double size;
  final ShapeBorder shape;
  final Curve curve;
  final Widget? dialRoot;
  final bool useInkWell;

  AnimatedFloatingButton({
    Key? key,
    this.visible = true,
    this.callback,
    this.label,
    this.child,
    this.dialRoot,
    this.useInkWell = false,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.heroTag,
    this.elevation = 6.0,
    this.size = 56.0,
    this.shape = const CircleBorder(),
    this.curve = Curves.linear,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var margin = visible ? 0.0 : 28.0;

    return Container(
      constraints: BoxConstraints(
        minHeight: 0.0,
        minWidth: 0.0,
      ),
      height: size,
      child: AnimatedContainer(
        curve: curve,
        margin: EdgeInsets.all(margin),
        duration: Duration(milliseconds: 150),
        height: visible ? size : 0.0,
        child: useGestureOrInkWell(
          onLongPress: onLongPress,
          onTap: dialRoot != null ? callback : null,
          child: dialRoot != null
              ? dialRoot
              : label != null
                  ? FloatingActionButton.extended(
                      key: key,
                      icon: visible ? child : null,
                      shape: shape == CircleBorder() ? StadiumBorder() : shape,
                      label: visible
                          ? label ?? const SizedBox.shrink()
                          : const SizedBox.shrink(),
                      backgroundColor: backgroundColor,
                      foregroundColor: foregroundColor,
                      onPressed: callback,
                      tooltip: tooltip,
                      heroTag: heroTag,
                      elevation: elevation,
                      highlightElevation: elevation,
                    )
                  : FloatingActionButton(
                      key: key,
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

  Widget useGestureOrInkWell(
      {Function? onTap, Function? onLongPress, Widget? child}) {
    return useInkWell
        ? InkWell(
            onLongPress: onLongPress as void Function()?,
            onTap: onTap as void Function()?,
            child: child,
          )
        : GestureDetector(
            onLongPress: onLongPress as void Function()?,
            onTap: onTap as void Function()?,
            child: child,
          );
  }
}
