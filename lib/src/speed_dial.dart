import 'dart:math';
import 'package:flutter/material.dart';

import 'animated_child.dart';
import 'global_key_extension.dart';
import 'animated_floating_button.dart';
import 'background_overlay.dart';
import 'speed_dial_child.dart';
import 'speed_dial_direction.dart';

/// Builds the Speed Dial
class SpeedDial extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<SpeedDialChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  final String? tooltip;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? activeBackgroundColor;
  final Color? activeForegroundColor;
  final double elevation;
  final double buttonSize;
  final double childrenButtonSize;
  final ShapeBorder shape;
  final Gradient? gradient;
  final BoxShape gradientBoxShape;

  /// Whether speedDial initialize with open state or not, defaults to false.
  final bool isOpenOnStart;

  /// The color of the background overlay.
  final Color? overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData? animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData? animatedIconTheme;

  /// The icon of the main button, ignored if [animatedIcon] is non [null].
  final IconData? icon;

  /// The active icon of the main button, Defaults to icon if not specified, ignored if [animatedIcon] is non [null].
  final IconData? activeIcon;

  /// If true then rotation animation will be used when animating b/w activeIcon and icon.
  final bool useRotationAnimation;

  /// The angle of the iconRotation
  final double animationAngle;

  /// The theme for the icon generally includes color and size.
  final IconThemeData? iconTheme;

  /// The label of the main button.
  final Widget? label;

  /// The active label of the main button, Defaults to label if not specified.
  final Widget? activeLabel;

  /// Transition Builder between label and activeLabel, defaults to FadeTransition.
  final Widget Function(Widget, Animation<double>)? labelTransitionBuilder;

  /// Executed when the dial is opened.
  final VoidCallback? onOpen;

  /// Executed when the dial is closed.
  final VoidCallback? onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback? onPress;

  /// If true user is forced to close dial manually by tapping main button. WARNING: If true, overlay is not rendered.
  final bool closeManually;

  /// If true overlay is rendered, no matter if closeManually is true or false.
  final bool renderOverlay;

  /// Open or close the dial via a notification
  final ValueNotifier<bool>? openCloseDial;

  /// The speed of the animation in milliseconds
  final int animationSpeed;

  /// The margin of each child
  final EdgeInsets childMargin;

  /// The padding of each child
  final EdgeInsets childPadding;

  /// Add a space at between speed dial and children
  final double? spacing;

  /// Add a space between each children
  final double? spaceBetweenChildren;

  /// The direction of the children. Default is [SpeedDialDirection.up]
  final SpeedDialDirection direction;

  /// If Provided then it will replace the default Floating Action Button
  /// and will show the Widget Specified as dialRoot instead, it will also
  /// ignore backgroundColor, foregroundColor or any other property
  /// that was specific to FAB before like onPress, you will have to provide
  /// it again to your dialRoot button.
  final Widget Function(
      BuildContext context, bool open, VoidCallback toggleChildren)? dialRoot;

  /// This is the child of the FAB, if specified it will ignore icon, activeIcon.
  final Widget? child;

  /// This is the active child of the FAB, if specified it will animate b/w this
  /// and the child.
  final Widget? activeChild;

  final bool switchLabelPosition;

  const SpeedDial({
    Key? key,
    this.children = const [],
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.gradient,
    this.gradientBoxShape = BoxShape.rectangle,
    this.elevation = 6.0,
    this.buttonSize = 56.0,
    this.childrenButtonSize = 56.0,
    this.dialRoot,
    this.overlayOpacity = 0.8,
    this.overlayColor,
    this.tooltip,
    this.heroTag,
    this.animatedIcon,
    this.animatedIconTheme,
    this.icon,
    this.activeIcon,
    this.child,
    this.activeChild,
    this.switchLabelPosition = false,
    this.useRotationAnimation = true,
    this.animationAngle = pi / 2,
    this.iconTheme,
    this.label,
    this.activeLabel,
    this.labelTransitionBuilder,
    this.onOpen,
    this.onClose,
    this.direction = SpeedDialDirection.up,
    this.closeManually = false,
    this.renderOverlay = true,
    this.shape = const StadiumBorder(),
    this.curve = Curves.fastOutSlowIn,
    this.onPress,
    this.animationSpeed = 150,
    this.openCloseDial,
    this.isOpenOnStart = false,
    this.childMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    this.childPadding = const EdgeInsets.symmetric(vertical: 5),
    this.spaceBetweenChildren,
    this.spacing,
  }) : super(key: key);

  @override
  _SpeedDialState createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.animationSpeed),
    vsync: this,
  );
  bool _open = false;
  OverlayEntry? overlayEntry;
  OverlayEntry? backgroundOverlay;
  final LayerLink _layerLink = LayerLink();
  final dialKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    super.initState();
    widget.openCloseDial?.addListener(_onOpenCloseDial);
    Future.delayed(Duration.zero, () async {
      if (mounted && widget.isOpenOnStart) _toggleChildren();
    });
    if (widget.children.length > 5) {
      debugPrint(
          'Warning ! You are using more than 5 children, which is not compliant with Material design specs.');
    }
  }

  @override
  void dispose() {
    overlayEntry?.dispose();
    _controller.dispose();
    widget.openCloseDial?.removeListener(_onOpenCloseDial);
    super.dispose();
  }

  @override
  void didUpdateWidget(SpeedDial oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _controller.duration = Duration(milliseconds: widget.animationSpeed);
    }

    widget.openCloseDial?.removeListener(_onOpenCloseDial);
    widget.openCloseDial?.addListener(_onOpenCloseDial);
    super.didUpdateWidget(oldWidget);
  }

  void _onOpenCloseDial() {
    final show = widget.openCloseDial?.value;
    if (!mounted) return;
    if (_open != show) {
      _toggleChildren();
    }
  }

  void _toggleChildren() {
    if (!mounted) return;

    if (widget.children.isNotEmpty) {
      var newValue = !_open;
      toggleOverlay();
      if (widget.openCloseDial != null) widget.openCloseDial!.value = newValue;
      if (newValue && widget.onOpen != null) widget.onOpen?.call();
      if (!newValue && widget.onClose != null) widget.onClose?.call();
    } else if (widget.onOpen != null) {
      widget.onOpen?.call();
    }
  }

  List<Widget> _getChildrenList() {
    return widget.children
        .map((SpeedDialChild child) {
          int index = widget.children.indexOf(child);

          var childAnimation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index / widget.children.length,
                1.0,
                curve: Curves.ease,
              ),
            ),
          );

          return AnimatedChild(
            animation: childAnimation,
            index: index,
            margin: widget.spaceBetweenChildren != null
                ? EdgeInsets.fromLTRB(
                    widget.direction.isRight ? widget.spaceBetweenChildren! : 0,
                    widget.direction.isDown ? widget.spaceBetweenChildren! : 0,
                    widget.direction.isLeft ? widget.spaceBetweenChildren! : 0,
                    widget.direction.isUp ? widget.spaceBetweenChildren! : 0,
                  )
                : null,
            btnKey: child.key,
            useColumn: widget.direction.isLeft || widget.direction.isRight,
            visible: child.visible,
            switchLabelPosition: widget.switchLabelPosition,
            backgroundColor: child.backgroundColor,
            foregroundColor: child.foregroundColor,
            elevation: child.elevation,
            buttonSize: widget.childrenButtonSize,
            child: child.child,
            label: child.label,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            onTap: child.onTap,
            onLongPress: child.onLongPress,
            toggleChildren: () {
              if (!widget.closeManually) _toggleChildren();
            },
            shape: child.shape,
            heroTag: widget.heroTag != null
                ? '${widget.heroTag}-child-$index'
                : null,
            childMargin: widget.childMargin,
            childPadding: widget.childPadding,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  toggleOverlay() {
    if (_open) {
      _controller.reverse().whenComplete(() {
        overlayEntry?.remove();
        if (widget.renderOverlay && backgroundOverlay!.mounted) {
          backgroundOverlay?.remove();
        }
      });
    } else {
      if (_controller.isAnimating) {
        // overlayEntry?.remove();
        // backgroundOverlay?.remove();
        return;
      }
      overlayEntry = OverlayEntry(
          builder: (ctx) => Stack(
                fit: StackFit.loose,
                children: [
                  Positioned(
                      child: CompositedTransformFollower(
                    followerAnchor: widget.direction.isDown
                        ? widget.switchLabelPosition
                            ? Alignment.topLeft
                            : Alignment.topRight
                        : widget.direction.isUp
                            ? widget.switchLabelPosition
                                ? Alignment.bottomLeft
                                : Alignment.bottomRight
                            : widget.direction.isLeft
                                ? Alignment.centerRight
                                : widget.direction.isRight
                                    ? Alignment.centerLeft
                                    : Alignment.center,
                    offset: widget.direction.isDown
                        ? Offset(
                            widget.switchLabelPosition ||
                                    dialKey.globalPaintBounds == null
                                ? 0
                                : dialKey.globalPaintBounds!.size.width,
                            dialKey.globalPaintBounds!.size.height)
                        : widget.direction.isUp
                            ? Offset(
                                widget.switchLabelPosition ||
                                        dialKey.globalPaintBounds == null
                                    ? 0
                                    : dialKey.globalPaintBounds!.size.width,
                                0)
                            : widget.direction.isLeft
                                ? Offset(-10.0,
                                    dialKey.globalPaintBounds!.size.height / 2)
                                : widget.direction.isRight ||
                                        dialKey.globalPaintBounds == null
                                    ? Offset(
                                        dialKey.globalPaintBounds!.size.width +
                                            12,
                                        dialKey.globalPaintBounds!.size.height /
                                            2)
                                    : const Offset(-10.0, 0.0),
                    link: _layerLink,
                    showWhenUnlinked: false,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: widget.spacing != null
                            ? EdgeInsets.fromLTRB(
                                widget.direction.isRight ? widget.spacing! : 0,
                                widget.direction.isDown ? widget.spacing! : 0,
                                widget.direction.isLeft ? widget.spacing! : 0,
                                widget.direction.isUp ? widget.spacing! : 0,
                              )
                            : null,
                        child: _buildColumnOrRow(
                          widget.direction.isUp || widget.direction.isDown,
                          crossAxisAlignment: widget.switchLabelPosition
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: widget.direction.isDown ||
                                  widget.direction.isRight
                              ? _getChildrenList().reversed.toList()
                              : _getChildrenList(),
                        ),
                      ),
                    ),
                  )),
                ],
              ));
      if (widget.renderOverlay) {
        backgroundOverlay = OverlayEntry(
          builder: (ctx) {
            bool _dark = Theme.of(ctx).brightness == Brightness.dark;
            return BackgroundOverlay(
              dialKey: dialKey,
              layerLink: _layerLink,
              closeManually: widget.closeManually,
              tooltip: widget.tooltip,
              shape: widget.shape,
              onTap: _toggleChildren,
              // (_open && !widget.closeManually) ? _toggleChildren : null,
              animation: _controller,
              color: widget.overlayColor ??
                  (_dark ? Colors.grey[900] : Colors.white)!,
              opacity: widget.overlayOpacity,
            );
          },
        );
      }

      if (!mounted) return;

      _controller.forward();
      if (widget.renderOverlay) Overlay.of(context)!.insert(backgroundOverlay!);
      Overlay.of(context)!.insert(overlayEntry!);
    }

    if (!mounted) return;
    setState(() {
      _open = !_open;
    });
  }

  Widget _renderButton() {
    var child = widget.animatedIcon != null
        ? Container(
            child: Center(
              child: AnimatedIcon(
                icon: widget.animatedIcon!,
                progress: _controller,
                color: widget.animatedIconTheme?.color,
                size: widget.animatedIconTheme?.size,
              ),
            ),
            decoration: BoxDecoration(
              shape: widget.gradientBoxShape,
              gradient: widget.gradient,
            ),
          )
        : AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? _widget) =>
                Transform.rotate(
              angle:
                  (widget.activeChild != null || widget.activeIcon != null) &&
                          widget.useRotationAnimation
                      ? _controller.value * widget.animationAngle
                      : 0,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: widget.animationSpeed),
                  child: (widget.child != null && _controller.value < 0.4)
                      ? widget.child
                      : (widget.activeIcon == null &&
                                  widget.activeChild == null ||
                              _controller.value < 0.4)
                          ? Container(
                              child: Center(
                                child: widget.icon != null
                                    ? Icon(
                                        widget.icon,
                                        key: const ValueKey<int>(0),
                                        color: widget.iconTheme?.color,
                                        size: widget.iconTheme?.size,
                                      )
                                    : widget.child,
                              ),
                              decoration: BoxDecoration(
                                shape: widget.gradientBoxShape,
                                gradient: widget.gradient,
                              ),
                            )
                          : Transform.rotate(
                              angle:
                                  widget.useRotationAnimation ? -pi * 1 / 2 : 0,
                              child: widget.activeChild ??
                                  Container(
                                    child: Center(
                                      child: Icon(
                                        widget.activeIcon,
                                        key: const ValueKey<int>(1),
                                        color: widget.iconTheme?.color,
                                        size: widget.iconTheme?.size,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: widget.gradientBoxShape,
                                      gradient: widget.gradient,
                                    ),
                                  ),
                            )),
            ),
          );

    var label = AnimatedSwitcher(
      duration: Duration(milliseconds: widget.animationSpeed),
      transitionBuilder: widget.labelTransitionBuilder ??
          (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
      child: (!_open || widget.activeLabel == null)
          ? widget.label
          : widget.activeLabel,
    );

    final backgroundColorTween = ColorTween(
        begin: widget.backgroundColor,
        end: widget.activeBackgroundColor ?? widget.backgroundColor);
    final foregroundColorTween = ColorTween(
        begin: widget.foregroundColor,
        end: widget.activeForegroundColor ?? widget.foregroundColor);

    var animatedFloatingButton = AnimatedBuilder(
      animation: _controller,
      builder: (context, ch) => CompositedTransformTarget(
          link: _layerLink,
          key: dialKey,
          child: AnimatedFloatingButton(
            visible: widget.visible,
            tooltip: widget.tooltip,
            dialRoot: widget.dialRoot != null
                ? widget.dialRoot!(context, _open, _toggleChildren)
                : null,
            backgroundColor: widget.backgroundColor != null
                ? backgroundColorTween.lerp(_controller.value)
                : null,
            foregroundColor: widget.foregroundColor != null
                ? foregroundColorTween.lerp(_controller.value)
                : null,
            elevation: widget.elevation,
            onLongPress: _toggleChildren,
            callback: (_open || widget.onPress == null)
                ? _toggleChildren
                : widget.onPress,
            size: widget.buttonSize,
            label: widget.label != null ? label : null,
            child: child,
            heroTag: widget.heroTag,
            shape: widget.shape,
          )),
    );

    return animatedFloatingButton;
  }

  Widget _buildColumnOrRow(bool isColumn,
      {CrossAxisAlignment? crossAxisAlignment,
      MainAxisAlignment? mainAxisAlignment,
      required List<Widget> children,
      MainAxisSize? mainAxisSize}) {
    return isColumn
        ? Column(
            mainAxisSize: mainAxisSize ?? MainAxisSize.max,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            children: children,
          )
        : Row(
            mainAxisSize: mainAxisSize ?? MainAxisSize.max,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            children: children,
          );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _renderButton(),
      onWillPop: () async {
        if (_open) {
          _toggleChildren();
          return false;
        }
        return true;
      },
    );
  }
}
