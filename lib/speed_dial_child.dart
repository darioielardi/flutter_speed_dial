import 'package:flutter/material.dart';

class SpeedDialChild {
  /// The label to render to the left of the button
  final String label;

  /// The style of the label
  final TextStyle labelStyle;

  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final VoidCallback onTap;
  final ShapeBorder shape;

  SpeedDialChild({
    this.label,
    this.labelStyle,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.shape,
  });
}
