import 'package:flutter/material.dart';

/// Provides data for a speed dial child
class SpeedDialChild {
  /// The key of the speed dial child.
  final Key? key;

  /// The label to render to the left of the button
  final String? label;

  /// The Shadow for [label] String
  final List<BoxShadow>? labelShadow;

  /// The style of the label
  final TextStyle? labelStyle;

  /// The background color of the label
  final Color? labelBackgroundColor;

  /// If this is provided it will replace the default widget, therefore [label],
  /// [labelStyle] and [labelBackgroundColor] should be null
  final Widget? labelWidget;

  /// The child widget for this `SpeedDialChild`
  final Widget? child;

  /// The color of the background of this `SpeedDialChild`
  final Color? backgroundColor;

  /// The color of the foreground of this `SpeedDialChild`
  final Color? foregroundColor;

  /// The intensity of the shadow for this `SpeedDialChild`
  final double? elevation;

  /// The action that is performed after tapping this `SpeedDialChild`
  final VoidCallback? onTap;

  /// The action that is performed after long pressing this `SpeedDialChild`
  final VoidCallback? onLongPress;

  /// The shape of this `SpeedDialChild`
  final ShapeBorder? shape;

  /// Whether this `SpeedDialChild` is visible or not
  final bool visible;

  SpeedDialChild({
    this.key,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.labelShadow,
    this.child,
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.onLongPress,
    this.shape,
  });
}
