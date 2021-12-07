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
  final Size size;
  final ShapeBorder shape;
  final Curve curve;
  final Widget? dialRoot;
  final bool useInkWell;

  const AnimatedFloatingButton({
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
    this.size = const Size(56.0, 56.0),
    this.shape = const CircleBorder(),
    this.curve = Curves.fastOutSlowIn,
    this.onLongPress,
  }) : super(key: key);

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.dialRoot == null
        ? AnimatedContainer(
            curve: widget.curve,
            duration: const Duration(milliseconds: 150),
            height: widget.visible ? widget.size.height : 0,
            child: FittedBox(
              child: GestureDetector(
                onLongPress: widget.onLongPress,
                child: widget.label != null
                    ? FloatingActionButton.extended(
                        icon: widget.visible ? widget.child : null,
                        label: widget.visible
                            ? widget.label!
                            : const SizedBox.shrink(),
                        shape: widget.shape is CircleBorder
                            ? const StadiumBorder()
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
            duration: const Duration(milliseconds: 150),
            curve: widget.curve,
            child: Container(
              child: widget.visible
                  ? widget.dialRoot
                  : const SizedBox(height: 0, width: 0),
            ),
          );
  }
}
