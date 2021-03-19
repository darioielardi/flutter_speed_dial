library flutter_speed_dial;

import 'package:flutter/material.dart';
import 'global_key_extension.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  final bool isDark;
  final GlobalKey dialKey;
  final LayerLink layerLink;

  BackgroundOverlay({
    Key? key,
    required Animation<double> animation,
    required this.dialKey,
    required this.layerLink,
    this.color = Colors.white,
    required this.isDark,
    this.opacity = 0.7,
  }) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          color.withOpacity(opacity * animation.value), BlendMode.srcOut),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                color: color, backgroundBlendMode: BlendMode.dstOut),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              child: Container(
                width: dialKey.globalPaintBounds!.size.width,
                height: dialKey.globalPaintBounds!.size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
