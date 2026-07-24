import 'dart:math' as math;

import 'package:cardifly/ui/components/app_loader.dart';
import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';

/// State machine for the custom refresh controller.
enum AppRefreshStatus { idle, dragging, armed, refreshing, completed, failed }

/// Reusable controller for [AppPullToRefresh].
class AppRefreshController extends ChangeNotifier {
  AppRefreshController({double? initialScrollOffset})
      : scrollController = ScrollController(
          initialScrollOffset: initialScrollOffset ?? 0,
        );

  final ScrollController scrollController;

  AppRefreshStatus _status = AppRefreshStatus.idle;
  bool _hasMore = true;
  bool _loadingMore = false;

  AppRefreshStatus get status => _status;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _loadingMore;
  bool get isRefreshing => _status == AppRefreshStatus.refreshing;

  void _setStatus(AppRefreshStatus s) {
    if (_status == s) return;
    _status = s;
    notifyListeners();
  }

  void refreshCompleted() {
    _hasMore = true;
    _setStatus(AppRefreshStatus.completed);
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      _setStatus(AppRefreshStatus.idle);
    });
  }

  void refreshFailed() {
    _setStatus(AppRefreshStatus.failed);
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      _setStatus(AppRefreshStatus.idle);
    });
  }

  void loadNoData() {
    _hasMore = false;
    _loadingMore = false;
    notifyListeners();
  }

  void loadComplete() {
    _loadingMore = false;
    notifyListeners();
  }

  void loadFailed() {
    _loadingMore = false;
    notifyListeners();
  }

  void _startLoadMore() {
    if (_loadingMore) return;
    _loadingMore = true;
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

typedef AsyncCallback = Future<void> Function();

/// Custom pull-to-refresh + pull-up-load-more container.
/// The refresh header runs a wave → orbit → wave dots animation.
class AppPullToRefresh extends StatefulWidget {
  const AppPullToRefresh({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.onLoadMore,
    required this.child,
    this.triggerDistance = 64,
    this.headerHeight = 46,
  });

  final AppRefreshController controller;
  final AsyncCallback onRefresh;
  final AsyncCallback? onLoadMore;
  final Widget child;
  final double triggerDistance;
  final double headerHeight;

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh> {
  double _dragOffset = 0;
  bool _armed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final c = widget.controller;
    if (widget.onLoadMore == null || !c.hasMore || c.isLoadingMore) return;
    final sc = c.scrollController;
    if (!sc.hasClients) return;
    if (sc.position.pixels >= sc.position.maxScrollExtent - 120) {
      _triggerLoadMore();
    }
  }

  Future<void> _triggerLoadMore() async {
    widget.controller._startLoadMore();
    try {
      await widget.onLoadMore?.call();
    } finally {
      if (widget.controller._loadingMore) widget.controller.loadComplete();
    }
  }

  bool _handleNotification(ScrollNotification n) {
    final c = widget.controller;
    if (c.isRefreshing) return false;
    if (n is OverscrollNotification && n.overscroll < 0) {
      setState(() {
        _dragOffset = math.min(
          widget.triggerDistance * 1.6,
          _dragOffset - n.overscroll,
        );
        _armed = _dragOffset >= widget.triggerDistance;
      });
      c._setStatus(AppRefreshStatus.dragging);
    } else if (n is ScrollUpdateNotification && n.metrics.pixels < 0) {
      setState(() {
        _dragOffset = -n.metrics.pixels;
        _armed = _dragOffset >= widget.triggerDistance;
      });
      c._setStatus(
        _armed ? AppRefreshStatus.armed : AppRefreshStatus.dragging,
      );
    } else if (n is ScrollEndNotification) {
      if (_armed) {
        _armed = false;
        _dragOffset = widget.triggerDistance;
        _run();
      } else {
        setState(() => _dragOffset = 0);
      }
    }
    return false;
  }

  Future<void> _run() async {
    final c = widget.controller;
    c._setStatus(AppRefreshStatus.refreshing);
    setState(() {});
    try {
      await widget.onRefresh();
      c.refreshCompleted();
    } catch (_) {
      c.refreshFailed();
    } finally {
      if (mounted) setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleNotification,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final status = widget.controller.status;
          final showHeader = _dragOffset > 0 ||
              status == AppRefreshStatus.refreshing ||
              status == AppRefreshStatus.completed ||
              status == AppRefreshStatus.failed;
          final offset = status == AppRefreshStatus.refreshing
              ? widget.headerHeight
              : _dragOffset;
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(
                  top: offset.clamp(0, widget.headerHeight),
                ),
                child: widget.child,
              ),
              if (showHeader)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: offset.clamp(0, widget.headerHeight),
                  child: _AppRefreshHeader(
                    progress: (_dragOffset / widget.triggerDistance)
                        .clamp(0.0, 1.0),
                    status: status,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AppRefreshHeader extends StatelessWidget {
  const _AppRefreshHeader({required this.progress, required this.status});

  final double progress;
  final AppRefreshStatus status;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (status) {
      case AppRefreshStatus.refreshing:
        // Wave → orbit → wave animation while refreshing.
        content = const _WaveOrbitDots();
      case AppRefreshStatus.completed:
        content = const Icon(
          Icons.check_rounded,
          color: Colors.green,
          size: 16,
        );
      case AppRefreshStatus.failed:
        content = const Icon(
          Icons.close_rounded,
          color: Colors.redAccent,
          size: 16,
        );
      case AppRefreshStatus.armed:
      case AppRefreshStatus.dragging:
      case AppRefreshStatus.idle:
        // Static "..." dots that "fill in" as user pulls.
        content = _PullDotsPreview(progress: progress);
    }
    return Center(child: content);
  }
}

/// Three dots that first bounce in a wave, then slide into a rotating
/// circular orbit, then morph back into the wave. Loops indefinitely.
class _WaveOrbitDots extends StatefulWidget {
  const _WaveOrbitDots();

  @override
  State<_WaveOrbitDots> createState() => _WaveOrbitDotsState();
}

class _WaveOrbitDotsState extends State<_WaveOrbitDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 28,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _WaveOrbitPainter(
            progress: _controller.value,
            color: Constants.appPrimaryColor,
          ),
        ),
      ),
    );
  }
}

class _WaveOrbitPainter extends CustomPainter {
  _WaveOrbitPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  // Loop breakpoints (fractions of the full animation cycle).
  static const double _p1End = 0.28; // wave-in
  static const double _p2End = 0.38; // line → circle morph
  static const double _p3End = 0.62; // full circular orbit
  static const double _p4End = 0.72; // circle → line morph
  // 0.72 → 1.00 = wave-out

  // Sequential-bounce wave: each dot lights up in turn, guaranteed to
  // return to y=0 at both ends of the phase (so morph transitions and
  // the overall loop are continuous).
  static double _waveY(double phaseT, int i, double amplitude) {
    const dotStagger = 0.18;
    const dotDuration = 0.55;
    final start = i * dotStagger;
    final localT = ((phaseT - start) / dotDuration).clamp(0.0, 1.0);
    if (localT <= 0 || localT >= 1) return 0;
    return -math.sin(localT * math.pi) * amplitude;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const dotRadius = 2.8;
    const spacing = 5.0;
    const orbitRadius = 9.0;
    const waveAmplitude = dotRadius * 2.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final t = progress;

    Offset linePos(int i, double waveT) {
      final lineX = centerX + (i - 1) * (dotRadius * 2 + spacing);
      return Offset(lineX, centerY + _waveY(waveT, i, waveAmplitude));
    }

    Offset circlePos(int i, double rotT) {
      final baseAngle = (2 * math.pi * i / 3) - math.pi / 2;
      final angle = baseAngle + rotT * math.pi * 2;
      return Offset(
        centerX + math.cos(angle) * orbitRadius,
        centerY + math.sin(angle) * orbitRadius,
      );
    }

    for (var i = 0; i < 3; i++) {
      Offset pos;
      double alpha;

      if (t < _p1End) {
        // Phase 1 — wave rippling through the "..." line.
        final wt = t / _p1End;
        pos = linePos(i, wt);
        final bounceIntensity =
            (-_waveY(wt, i, waveAmplitude)) / waveAmplitude;
        alpha = 0.55 + 0.40 * bounceIntensity;
      } else if (t < _p2End) {
        // Phase 2 — dots slide out of the line into a triangle
        // arrangement (start of the orbit).
        final mt = (t - _p1End) / (_p2End - _p1End);
        pos = Offset.lerp(
          linePos(i, 1.0),
          circlePos(i, 0),
          Curves.easeInOutCubic.transform(mt),
        )!;
        alpha = 0.85;
      } else if (t < _p3End) {
        // Phase 3 — dots orbit around the center for a full 2π turn.
        final rt = (t - _p2End) / (_p3End - _p2End);
        pos = circlePos(i, rt);
        alpha = 0.95;
      } else if (t < _p4End) {
        // Phase 4 — orbit unfolds, dots return to the "..." line.
        final mt = (t - _p3End) / (_p4End - _p3End);
        pos = Offset.lerp(
          circlePos(i, 1.0),
          linePos(i, 0),
          Curves.easeInOutCubic.transform(mt),
        )!;
        alpha = 0.85;
      } else {
        // Phase 5 — final wave rippling back through the line,
        // ready to loop seamlessly into Phase 1.
        final wt = (t - _p4End) / (1.0 - _p4End);
        pos = linePos(i, wt);
        final bounceIntensity =
            (-_waveY(wt, i, waveAmplitude)) / waveAmplitude;
        alpha = 0.55 + 0.40 * bounceIntensity;
      }

      canvas.drawCircle(
        pos,
        dotRadius,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveOrbitPainter old) =>
      old.progress != progress || old.color != color;
}

/// Non-animated three dots preview: as the user drags, each dot
/// gains opacity in sequence to visually hint the upcoming typing loader.
class _PullDotsPreview extends StatelessWidget {
  const _PullDotsPreview({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 6),
      painter: _PullDotsPainter(progress: progress),
    );
  }
}

class _PullDotsPainter extends CustomPainter {
  _PullDotsPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const dotCount = 3;
    const spacing = 3.0;
    final radius = size.height / 2;

    for (var i = 0; i < dotCount; i++) {
      final threshold = (i + 1) / dotCount;
      final localProgress = (progress / threshold).clamp(0.0, 1.0);
      final alpha = 0.2 + 0.8 * localProgress;
      final cx = radius + i * (size.height + spacing);
      canvas.drawCircle(
        Offset(cx, size.height / 2),
        radius,
        Paint()..color = Constants.appPrimaryColor.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PullDotsPainter old) =>
      old.progress != progress;
}

/// Compact load-more footer with the typing dots.
class AppLoadMoreFooter extends StatelessWidget {
  const AppLoadMoreFooter({super.key, required this.controller});

  final AppRefreshController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(child: AppLoader(size: 5)),
          );
        }
        if (!controller.hasMore) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                'Vous avez tout vu',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.displaySmall?.color,
                ),
              ),
            ),
          );
        }
        return const SizedBox(height: 8);
      },
    );
  }
}
