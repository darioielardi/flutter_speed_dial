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
  final GlobalKey? dialKey;
  final Widget? dialRoot;
  final bool useInkWell;

  AnimatedFloatingButton({
    Key? key,
    this.visible = true,
    this.callback,
    this.label,
    this.child,
    this.dialKey,
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
    return AnimatedContainer(
      curve: curve,
      duration: Duration(milliseconds: 150),
      height: visible ? size : 0.0,
      child: Container(
        height: size,
        key: dialKey,
        child: FittedBox(
          child: GestureDetector(
            onLongPress: onLongPress,
            child: dialRoot != null && !(dialRoot! is Container)
                ? dialRoot
                : label != null
                    ? FloatingActionButton.extended(
                        icon: visible ? child : null,
                        shape: shape is CircleBorder ? StadiumBorder() : shape,
                        label: visible ? label! : SizedBox.shrink(),
                        backgroundColor: backgroundColor,
                        foregroundColor: foregroundColor,
                        onPressed: callback,
                        tooltip: tooltip,
                        heroTag: heroTag,
                        elevation: elevation,
                        highlightElevation: elevation,
                      )
                    : FloatingActionButton(
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
      ),
    );
  }
}
