import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'animated_child.dart';
import 'global_key_extension.dart';
import 'animated_floating_button.dart';
import 'background_overlay.dart';
import 'speed_dial_child.dart';
import 'speed_dial_direction.dart';

typedef AsyncChildrenBuilder = Future<List<SpeedDialChild>> Function(
    BuildContext context);

/// Builds the Speed Dial
class SpeedDial extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<SpeedDialChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  /// The tooltip of this `SpeedDial`
  final String? tooltip;

  /// The hero tag used for the fab inside this `SpeedDial`
  final String? heroTag;

  /// The color of the background of this `SpeedDial`
  final Color? backgroundColor;

  /// The color of the foreground of this `SpeedDial`
  final Color? foregroundColor;

  /// The color of the background of this `SpeedDial` when it is open
  final Color? activeBackgroundColor;

  /// The color of the foreground of this `SpeedDial` when it is open
  final Color? activeForegroundColor;

  /// The intensity of the shadow for this `SpeedDial`
  final double elevation;

  /// The size for this `SpeedDial` button
  final Size buttonSize;

  /// The size for this `SpeedDial` children
  final Size childrenButtonSize;

  /// The shape of this `SpeedDial`
  final ShapeBorder shape;

  /// The gradient decoration for this `SpeedDial`
  final Gradient? gradient;

  /// The shape of the gradient decoration for this `SpeedDial`
  final BoxShape gradientBoxShape;

  /// Whether speedDial initialize with open state or not, defaults to false.
  final bool isOpenOnStart;

  /// Whether to close the dial on pop if it's open.
  final bool closeDialOnPop;

  /// The color of the background overlay.
  final Color? overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconData? animatedIcon;

  /// The theme for the animated icon.
  /// This is only applied to [animatedIcon].
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
  /// The iconTheme is only applied to [child] and [activeChild] or [icon] and [activeIcon].
  final IconThemeData? iconTheme;

  /// The label of the main button.
  final Widget? label;

  /// The active label of the main button, Defaults to label if not specified.
  final Widget? activeLabel;

  /// Transition Builder between label and activeLabel, defaults to FadeTransition.
  final Widget Function(Widget, Animation<double>)? labelTransitionBuilder;

  /// Repopulate children every time just before opening the dial. If you provide [onOpenBuilder]
  /// then you must also provide a non-const [children] (e.g. `children: []`) since [children] is
  /// const by default and cannot be modified.
  final AsyncChildrenBuilder? onOpenBuilder;

  /// Executed when the dial is opened.
  final VoidCallback? onOpen;

  /// Executed when the dial is closed.
  final VoidCallback? onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback? onPress;

  /// If true tapping on speed dial's children will not close the dial anymore.
  final bool closeManually;

  /// If true overlay is rendered.
  final bool renderOverlay;

  /// Open or close the dial via a notification
  final ValueNotifier<bool>? openCloseDial;

  /// The duration of the animation or the duration till which animation is played.
  final Duration animationDuration;

  /// The margin of each child
  final EdgeInsetsGeometry childMargin;

  /// The padding of each child
  final EdgeInsetsGeometry childPadding;

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

  /// This is the animation of the child of the FAB, if specified it will animate b/w this
  final Curve? animationCurve;

  /// Use mini fab for the speed dial
  final bool mini;

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
    this.buttonSize = const Size(56.0, 56.0),
    this.childrenButtonSize = const Size(56.0, 56.0),
    this.dialRoot,
    this.mini = false,
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
    this.onOpenBuilder,
    this.onOpen,
    this.onClose,
    this.direction = SpeedDialDirection.up,
    this.closeManually = false,
    this.renderOverlay = true,
    this.shape = const StadiumBorder(),
    this.curve = Curves.fastOutSlowIn,
    this.onPress,
    this.animationDuration = const Duration(milliseconds: 150),
    this.openCloseDial,
    this.isOpenOnStart = false,
    this.closeDialOnPop = true,
    this.childMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    this.childPadding = const EdgeInsets.symmetric(vertical: 5),
    this.spaceBetweenChildren,
    this.spacing,
    this.animationCurve,
  }) : super(key: key);

  @override
  State createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.animationDuration,
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
    _checkChildren();
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      if (overlayEntry!.mounted) overlayEntry!.remove();
      overlayEntry!.dispose();
    }
    if (widget.renderOverlay && backgroundOverlay != null) {
      if (backgroundOverlay!.mounted) backgroundOverlay!.remove();
      backgroundOverlay!.dispose();
    }
    _controller.dispose();
    widget.openCloseDial?.removeListener(_onOpenCloseDial);
    super.dispose();
  }

  @override
  void didUpdateWidget(SpeedDial oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _controller.duration = widget.animationDuration;
    }

    widget.openCloseDial?.removeListener(_onOpenCloseDial);
    widget.openCloseDial?.addListener(_onOpenCloseDial);
    super.didUpdateWidget(oldWidget);
  }

  void _checkChildren() {
    if (widget.children.length > 5) {
      debugPrint(
          'Warning ! You are using more than 5 children, which is not compliant with Material design specs.');
    }
  }

  void _onOpenCloseDial() {
    final show = widget.openCloseDial?.value;
    if (!mounted) return;
    if (_open != show) {
      _toggleChildren();
    }
  }

  void _toggleChildren() async {
    if (!mounted) return;

    final opening = !_open;
    if (opening && widget.onOpenBuilder != null) {
      widget.children.clear();
      final widgets = await widget.onOpenBuilder!(context);
      widget.children.addAll(widgets);
      _checkChildren();
    }

    if (widget.children.isNotEmpty) {
      toggleOverlay();
      widget.openCloseDial?.value = opening;
      opening ? widget.onOpen?.call() : widget.onClose?.call();
    } else {
      widget.onOpen?.call();
    }
  }

  toggleOverlay() {
    if (_open) {
      _controller.reverse().whenComplete(() {
        overlayEntry?.remove();
        if (widget.renderOverlay &&
            backgroundOverlay != null &&
            backgroundOverlay!.mounted) {
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
        builder: (ctx) => _ChildrensOverlay(
          widget: widget,
          dialKey: dialKey,
          layerLink: _layerLink,
          controller: _controller,
          toggleChildren: _toggleChildren,
          animationCurve: widget.animationCurve,
        ),
      );
      if (widget.renderOverlay) {
        backgroundOverlay = OverlayEntry(
          builder: (ctx) {
            bool dark = Theme.of(ctx).brightness == Brightness.dark;
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
                  (dark ? Colors.grey[900] : Colors.white)!,
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
            decoration: BoxDecoration(
              shape: widget.gradientBoxShape,
              gradient: widget.gradient,
            ),
            child: Center(
              child: AnimatedIcon(
                icon: widget.animatedIcon!,
                progress: _controller,
                color: widget.animatedIconTheme?.color,
                size: widget.animatedIconTheme?.size,
              ),
            ),
          )
        : AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) => Transform.rotate(
              angle:
                  (widget.activeChild != null || widget.activeIcon != null) &&
                          widget.useRotationAnimation
                      ? _controller.value * widget.animationAngle
                      : 0,
              child: AnimatedSwitcher(
                  duration: widget.animationDuration,
                  child: (widget.child != null && _controller.value < 0.4)
                      ? widget.child
                      : (widget.activeIcon == null &&
                                  widget.activeChild == null ||
                              _controller.value < 0.4)
                          ? Container(
                              decoration: BoxDecoration(
                                shape: widget.gradientBoxShape,
                                gradient: widget.gradient,
                              ),
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
                            )
                          : Transform.rotate(
                              angle:
                                  widget.useRotationAnimation ? -pi * 1 / 2 : 0,
                              child: widget.activeChild ??
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: widget.gradientBoxShape,
                                      gradient: widget.gradient,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        widget.activeIcon,
                                        key: const ValueKey<int>(1),
                                        color: widget.iconTheme?.color,
                                        size: widget.iconTheme?.size,
                                      ),
                                    ),
                                  ),
                            )),
            ),
          );

    var label = AnimatedSwitcher(
      duration: widget.animationDuration,
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
            mini: widget.mini,
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
            heroTag: widget.heroTag,
            shape: widget.shape,
            child: child,
          )),
    );

    return animatedFloatingButton;
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb || !Platform.isIOS) && widget.closeDialOnPop
        ? WillPopScope(
            child: _renderButton(),
            onWillPop: () async {
              if (_open) {
                _toggleChildren();
                return false;
              }
              return true;
            },
          )
        : _renderButton();
  }
}

class _ChildrensOverlay extends StatelessWidget {
  const _ChildrensOverlay({
    Key? key,
    required this.widget,
    required this.layerLink,
    required this.dialKey,
    required this.controller,
    required this.toggleChildren,
    this.animationCurve,
  }) : super(key: key);

  final SpeedDial widget;
  final GlobalKey<State<StatefulWidget>> dialKey;
  final LayerLink layerLink;
  final AnimationController controller;
  final Function toggleChildren;
  final Curve? animationCurve;

  List<Widget> _getChildrenList() {
    return widget.children
        .map((SpeedDialChild child) {
          int index = widget.children.indexOf(child);

          return AnimatedChild(
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(
                  index / widget.children.length,
                  1.0,
                  curve: widget.animationCurve ?? Curves.ease,
                ),
              ),
            ),
            index: index,
            margin: widget.spaceBetweenChildren != null
                ? EdgeInsetsDirectional.fromSTEB(
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
            label: child.label,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            labelShadow: child.labelShadow,
            onTap: child.onTap,
            onLongPress: child.onLongPress,
            toggleChildren: () {
              if (!widget.closeManually) toggleChildren();
            },
            shape: child.shape,
            heroTag: widget.heroTag != null
                ? '${widget.heroTag}-child-$index'
                : null,
            childMargin: widget.childMargin,
            childPadding: widget.childPadding,
            child: child.child,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    TextDirection textDirection = Directionality.of(context);
    bool isRTL = textDirection == TextDirection.rtl;

    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
            child: CompositedTransformFollower(
          followerAnchor: widget.direction.isDown
              ? widget.switchLabelPosition
                  ? Alignment.topLeft
                  : Alignment.topRight
              : widget.direction.isUp
                  ? widget.switchLabelPosition || isRTL
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight
                  : widget.direction.isLeft
                      ? Alignment.centerRight
                      : widget.direction.isRight || isRTL
                          ? Alignment.centerLeft
                          : Alignment.center,
          offset: widget.direction.isDown
              ? Offset(
                  Offset.fromDirection(
                          isRTL ? 0 : 3.14159,
                          (widget.switchLabelPosition ||
                                      isRTL ||
                                      dialKey.globalPaintBounds == null
                                  ? 0
                                  : dialKey.globalPaintBounds!.size.width) +
                              max(widget.childrenButtonSize.height - 56, 0) / 2)
                      .dx,
                  dialKey.globalPaintBounds!.size.height)
              : widget.direction.isUp
                  ? Offset.fromDirection(
                      isRTL ? 3.14159 : 0,
                      (widget.switchLabelPosition ||
                                  isRTL ||
                                  dialKey.globalPaintBounds == null
                              ? 0
                              : dialKey.globalPaintBounds!.size.width) +
                          max(widget.childrenButtonSize.width - 56, 0) / 2)
                  // ? Offset(
                  //     (widget.switchLabelPosition ||
                  //                 dialKey.globalPaintBounds == null
                  //             ? 0
                  //             : dialKey.globalPaintBounds!.size.width) +
                  //         max(widget.childrenButtonSize.width - 56, 0) / 2,
                  //     0)
                  : widget.direction.isLeft
                      ? Offset(
                          -10.0,
                          dialKey.globalPaintBounds == null
                              ? 0
                              : dialKey.globalPaintBounds!.size.height / 2)
                      : widget.direction.isRight &&
                              dialKey.globalPaintBounds != null
                          ? Offset(dialKey.globalPaintBounds!.size.width + 12,
                              dialKey.globalPaintBounds!.size.height / 2)
                          : const Offset(-10.0, 0),
          link: layerLink,
          showWhenUnlinked: false,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.direction.isUp || widget.direction.isDown
                    ? max(widget.buttonSize.width - 56, 0) / 2
                    : 0,
              ),
              margin: widget.spacing != null
                  ? EdgeInsetsDirectional.fromSTEB(
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
                children: widget.direction.isDown || widget.direction.isRight
                    ? _getChildrenList().reversed.toList()
                    : _getChildrenList(),
              ),
            ),
          ),
        )),
      ],
    );
  }
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
