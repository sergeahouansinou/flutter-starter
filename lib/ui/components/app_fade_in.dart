import 'dart:async';

import 'package:flutter/material.dart';

/// Direction the child travels *from* while fading in.
enum AppFadeDirection {
  /// Starts below its final position and slides up (the default).
  fromBottom,

  /// Starts above and slides down.
  fromTop,

  /// Starts to the left and slides right.
  fromLeft,

  /// Starts to the right and slides left.
  fromRight,
}

/// Fades a subtree in while sliding it into place — a configurable entrance
/// animation that plays once when the widget is first mounted.
///
/// [direction] chooses where the slide comes from (bottom by default) and
/// [offset] how far it travels. Reusable anywhere in the app.
///
/// ```dart
/// AppFadeIn(child: Text('Hello'))                       // default: from bottom
/// AppFadeIn(direction: AppFadeDirection.fromLeft, ...)  // slides in from left
/// AppFadeIn(offset: 0, child: Icon(Icons.star))         // pure fade, no slide
/// AppFadeIn(delay: Duration(milliseconds: 150), ...)    // delayed entrance
/// ```
///
/// For a staggered "cascade" of several children, see [AppFadeIn.stagger].
class AppFadeIn extends StatefulWidget {
  const AppFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1250),
    this.delay = Duration.zero,
    this.offset = 24,
    this.direction = AppFadeDirection.fromBottom,
    this.curve = Curves.easeOutCubic,
    this.animate = true,
  });

  final Widget child;

  /// How long the entrance takes.
  final Duration duration;

  /// Waits this long after mount before starting — handy for staggering.
  final Duration delay;

  /// Distance, in logical pixels, the child travels while fading in. `0` gives
  /// a pure fade with no slide.
  final double offset;

  /// Where the slide originates. Defaults to [AppFadeDirection.fromBottom].
  final AppFadeDirection direction;

  final Curve curve;

  /// When `false`, the child is shown instantly with no animation.
  final bool animate;

  /// Wraps each of [children] in an [AppFadeIn] with an incrementally growing
  /// [delay], producing a staggered cascade. Returns a list ready to drop into
  /// any `Column`, `ListView`, `Wrap`, etc.
  ///
  /// ```dart
  /// Column(children: AppFadeIn.stagger([widgetA, widgetB, widgetC]))
  /// ```
  static List<Widget> stagger(
    List<Widget> children, {
    Duration duration = const Duration(milliseconds: 450),
    Duration initialDelay = Duration.zero,
    Duration interval = const Duration(milliseconds: 80),
    double offset = 24,
    AppFadeDirection direction = AppFadeDirection.fromBottom,
    Curve curve = Curves.easeOutCubic,
    bool animate = true,
  }) {
    return List<Widget>.generate(children.length, (i) {
      return AppFadeIn(
        duration: duration,
        delay: initialDelay + interval * i,
        offset: offset,
        direction: direction,
        curve: curve,
        animate: animate,
        child: children[i],
      );
    });
  }

  @override
  State<AppFadeIn> createState() => _AppFadeInState();
}

class _AppFadeInState extends State<AppFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _start();
  }

  void _start() {
    if (!widget.animate) {
      _controller.value = 1.0;
    } else if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppFadeIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    // Toggling `animate` on after the fact should reveal the child instantly.
    if (widget.animate != oldWidget.animate && !widget.animate) {
      _delayTimer?.cancel();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// The child's starting translation, before it settles to `Offset.zero`.
  Offset _beginOffset() {
    switch (widget.direction) {
      case AppFadeDirection.fromBottom:
        return Offset(0, widget.offset);
      case AppFadeDirection.fromTop:
        return Offset(0, -widget.offset);
      case AppFadeDirection.fromLeft:
        return Offset(-widget.offset, 0);
      case AppFadeDirection.fromRight:
        return Offset(widget.offset, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;

    final begin = _beginOffset();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value;
        return Opacity(
          // Clamp so curves that overshoot (e.g. easeOutBack) stay valid.
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: begin * (1 - t),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
