import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with TickerProviderStateMixin {
  AnimationController? _slideController;
  Animation<double>? _slideAnimation;

  AnimationController? _glowController;
  Animation<double>? _glowAnimation;

  double _fromIndex = 0.0;
  double _toIndex = 0.0;

  final List<IconData> _navIcons = const [
    Icons.home_rounded,
    Icons.access_time_rounded,
    Icons.pie_chart_rounded,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _ensureInitialized();
  }

  void _ensureInitialized() {
    if (_slideController == null) {
      _fromIndex = widget.currentIndex.toDouble();
      _toIndex = widget.currentIndex.toDouble();

      // 1. Slide transition controller
      _slideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 320),
      );

      _slideAnimation = CurvedAnimation(
        parent: _slideController!,
        curve: Curves.easeInOutCubic,
      );

      // 2. Interactive neon glow flare controller
      _glowController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      );

      _glowAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOutQuad)),
          weight: 22.0, // fast burst flare (approx 300ms)
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 78.0, // graceful decay back to clean resting state
        ),
      ]).animate(_glowController!);

      _glowController!.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant FloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureInitialized();
    if (oldWidget.currentIndex != widget.currentIndex) {
      _fromIndex = _toIndex;
      _toIndex = widget.currentIndex.toDouble();
      _slideController?.forward(from: 0.0);

      // Trigger neon glow flare on tab change
      _glowController?.forward(from: 0.0);
    }
  }

  void _handleTap(int index) {
    _ensureInitialized();
    if (index == widget.currentIndex) {
      // Re-trigger glow burst if tapped current tab
      _glowController?.forward(from: 0.0);
    }
    widget.onTap(index);
  }

  @override
  void dispose() {
    _slideController?.dispose();
    _glowController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureInitialized();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barBg = isDark ? const Color(0xFF1D1D26) : const Color(0xFF14141A);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    const double barWidth = 320.0;
    const double barHeight = 80.0;
    const double itemWidth = barWidth / 4;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12 + bottomPadding),
        child: SizedBox(
          width: barWidth,
          height: barHeight,
          child: AnimatedBuilder(
            animation: Listenable.merge([_slideAnimation!, _glowAnimation!]),
            builder: (context, child) {
              final double currentIndexValue = _fromIndex +
                  (_toIndex - _fromIndex) * _slideAnimation!.value;
              final double activeX = (currentIndexValue + 0.5) * itemWidth;
              final double glowValue = _glowAnimation!.value;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Curved Scooped Navigation Bar Background
                  CustomPaint(
                    size: const Size(barWidth, barHeight),
                    painter: CurvedNavBarPainter(
                      activeX: activeX,
                      barColor: barBg,
                      isDark: isDark,
                      notchDepth: 25.0,
                    ),
                  ),

                  // 2. Inactive Icons Row
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 16,
                    height: 64,
                    child: Row(
                      children: List.generate(_navIcons.length, (index) {
                        final double distance =
                            (currentIndexValue - index).abs();
                        final double opacity = distance.clamp(0.0, 1.0);

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _handleTap(index),
                            behavior: HitTestBehavior.opaque,
                            child: Center(
                              child: Opacity(
                                opacity: opacity,
                                child: Icon(
                                  _navIcons[index],
                                  size: 22,
                                  color: isDark
                                      ? const Color(0xFF90909E)
                                      : const Color(0xFF8A8A96),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // 3. Elevated Floating Lime Bubble Indicator
                  Positioned(
                    left: activeX - 25,
                    top: 3,
                    child: GestureDetector(
                      onTap: () => _handleTap(widget.currentIndex),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.lime,
                          shape: BoxShape.circle,
                          boxShadow: [
                            // 1. Clean crisp base drop shadow for elevation
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.45 : 0.25,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),

                            // 2. Interactive Neon Burst Flare (blooms on tap, then smoothly fades out!)
                            if (glowValue > 0.01) ...[
                              BoxShadow(
                                color: AppTheme.lime.withValues(
                                  alpha: (isDark ? 0.70 : 0.50) * glowValue,
                                ),
                                blurRadius:
                                    (isDark ? 22.0 : 16.0) * glowValue,
                                spreadRadius: 2.0 * glowValue,
                                offset: const Offset(0, 2),
                              ),
                              if (isDark)
                                BoxShadow(
                                  color: AppTheme.lime.withValues(
                                    alpha: 0.40 * glowValue,
                                  ),
                                  blurRadius: 36.0 * glowValue,
                                  spreadRadius: 4.0 * glowValue,
                                ),
                            ],
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _navIcons[widget.currentIndex],
                            size: 24,
                            color: AppTheme.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CurvedNavBarPainter extends CustomPainter {
  final double activeX;
  final Color barColor;
  final bool isDark;
  final double notchDepth;

  CurvedNavBarPainter({
    required this.activeX,
    required this.barColor,
    required this.isDark,
    this.notchDepth = 25.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final path = Path();
    const double barTop = 16.0;
    const double cornerRadius = 26.0;

    final double x = activeX;
    const double sW = 40.0;
    final double nD = notchDepth;

    // Top-left start
    path.moveTo(cornerRadius, barTop);

    // Line towards scoop shoulder
    final double notchLeft =
        (x - sW).clamp(cornerRadius, size.width - cornerRadius);
    final double notchRight =
        (x + sW).clamp(cornerRadius, size.width - cornerRadius);

    path.lineTo(notchLeft, barTop);

    // Smooth concave cutout curve (Scoop)
    path.cubicTo(
      x - sW * 0.55,
      barTop,
      x - sW * 0.45,
      barTop + nD,
      x,
      barTop + nD,
    );
    path.cubicTo(
      x + sW * 0.45,
      barTop + nD,
      x + sW * 0.55,
      barTop,
      notchRight,
      barTop,
    );

    // Line to top-right corner
    path.lineTo(size.width - cornerRadius, barTop);

    // Top-right corner
    path.arcToPoint(
      Offset(size.width, barTop + cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );

    // Right edge
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: const Radius.circular(cornerRadius),
    );

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );

    // Left edge
    path.lineTo(0, barTop + cornerRadius);

    // Top-left corner
    path.arcToPoint(
      const Offset(cornerRadius, barTop),
      radius: const Radius.circular(cornerRadius),
    );

    path.close();

    // Elevation drop shadow
    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: isDark ? 0.6 : 0.35),
      isDark ? 20 : 18,
      false,
    );

    // Draw solid bar body
    canvas.drawPath(path, paint);

    // Subtle outline stroke along the bar and scoop curve in dark mode
    if (isDark) {
      final borderPaint = Paint()
        ..color = const Color(0xFF333342)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CurvedNavBarPainter oldDelegate) {
    return oldDelegate.activeX != activeX ||
        oldDelegate.barColor != barColor ||
        oldDelegate.isDark != isDark;
  }
}
