import 'package:flutter/material.dart';

/// Provides data for a speed dial child
class SpeedDialChild {
  /// The label to render to the left of the button
  final String label;

  /// The style of the label
  final TextStyle labelStyle;

  /// The background color of the label
  final Color labelBackgroundColor;

  /// If this is provided it will replace the default widget, therefore [label],
  /// [labelStyle] and [labelBackgroundColor] should be null
  final Widget labelWidget;

  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final VoidCallback onTap;
  final ShapeBorder shape;

  SpeedDialChild({
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.shape,
  });
}
