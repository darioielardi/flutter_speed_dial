library flutter_speed_dial;

import 'package:flutter/material.dart';
import 'global_key_extension.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  final GlobalKey dialKey;
  final LayerLink layerLink;
  final ShapeBorder shape;
  final VoidCallback? onTap;
  final bool closeManually;
  final String? tooltip;

  const BackgroundOverlay({
    Key? key,
    this.onTap,
    required this.shape,
    required Animation<double> animation,
    required this.dialKey,
    required this.layerLink,
    required this.closeManually,
    required this.tooltip,
    this.color = Colors.white,
    this.opacity = 0.7,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
            color.withOpacity(opacity * animation.value), BlendMode.srcOut),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: closeManually ? null : onTap,
              child: Container(
                decoration: BoxDecoration(
                    color: color, backgroundBlendMode: BlendMode.dstOut),
              ),
            ),
            Positioned(
              width: dialKey.globalPaintBounds!.size.width,
              child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: () {
                    final Widget child = GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: dialKey.globalPaintBounds!.size.width,
                        height: dialKey.globalPaintBounds!.size.height,
                        decoration: ShapeDecoration(
                          shape: shape == const CircleBorder()
                              ? const StadiumBorder()
                              : shape,
                          color: Colors.white,
                        ),
                      ),
                    );
                    return tooltip != null && tooltip!.isNotEmpty
                        ? Tooltip(
                            message: tooltip!,
                            child: child,
                          )
                        : child;
                  }(),
                ),
              ),
            ),
          ],
        ));
  }
}
