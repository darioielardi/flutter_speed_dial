library flutter_speed_dial;

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/src/custom_hole_clipper.dart';
import 'global_key_extension.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  final GlobalKey dialKey;
  final LayerLink layerLink;

  BackgroundOverlay({
    Key? key,
    required Animation<double> animation,
    required this.dialKey,
    required this.layerLink,
    this.color = Colors.white,
    this.opacity = 0.7,
  }) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: opacity * animation.value,
          child: ClipPath(
      clipper: InvertedClipper(
        width: dialKey.globalPaintBounds!.size.width, 
        height: dialKey.globalPaintBounds!.size.height,
        dy: dialKey.offset.dy,
        dx: dialKey.offset.dx),
        child: Container(
              color: color,
        ),
      ),
          
    );
  }
}
