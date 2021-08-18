import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatefulWidget {
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
    this.curve = Curves.fastOutSlowIn,
    this.onLongPress,
  }) : super(key: key);

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return widget.dialRoot == null
        ? AnimatedContainer(
            curve: widget.curve,
            duration: Duration(milliseconds: 150),
            height: widget.visible ? widget.size : 0,
            child: FittedBox(
              child: GestureDetector(
                onLongPress: widget.onLongPress,
                child: widget.label != null
                    ? FloatingActionButton.extended(
                        icon: widget.visible ? widget.child : null,
                        label:
                            widget.visible ? widget.label! : SizedBox.shrink(),
                        shape: widget.shape is CircleBorder
                            ? StadiumBorder()
                            : widget.shape,
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: widget.foregroundColor,
                        onPressed: widget.callback,
                        tooltip: widget.tooltip,
                        heroTag: widget.heroTag,
                        elevation: widget.elevation,
                        highlightElevation: widget.elevation,
                      )
                    : FloatingActionButton(
                        child: widget.visible ? widget.child : null,
                        shape: widget.shape,
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: widget.foregroundColor,
                        onPressed: widget.callback,
                        tooltip: widget.tooltip,
                        heroTag: widget.heroTag,
                        elevation: widget.elevation,
                        highlightElevation: widget.elevation,
                      ),
              ),
            ),
          )
        : AnimatedSize(
            duration: Duration(milliseconds: 150),
            curve: widget.curve,
            child: Container(
              child: Container(
                child: widget.visible
                    ? widget.dialRoot
                    : Container(height: 0, width: 0),
              ),
            ),
          );
  }
}
