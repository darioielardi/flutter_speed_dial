import 'package:material_ui/material_ui.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  final Rect dialRect;
  final ShapeBorder shape;
  final VoidCallback? onTap;
  final bool closeManually;
  final String? tooltip;

  const BackgroundOverlay({
    super.key,
    this.onTap,
    required this.shape,
    required Animation<double> animation,
    required this.dialRect,
    required this.closeManually,
    required this.tooltip,
    this.color = Colors.white,
    this.opacity = 0.7,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return ColorFiltered(
        colorFilter: ColorFilter.mode(
            color.withValues(alpha: opacity * animation.value),
            BlendMode.srcOut),
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
            Positioned.fromRect(
              rect: dialRect,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: () {
                  final Widget child = GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: dialRect.width,
                      height: dialRect.height,
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
          ],
        ));
  }
}
