import 'dart:ui';
import 'package:flutter/material.dart';

class GlassyBadge extends StatelessWidget {
  final Widget? child;
  final String? emoji;
  final double size;
  final double emojiSize;
  final Color? glowColor;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Border? border;

  const GlassyBadge({
    super.key,
    this.child,
    this.emoji,
    this.size = 36.0,
    this.emojiSize = 18.0,
    this.glowColor,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.padding,
    this.border,
  });

  /// Factory for glassy country flags
  factory GlassyBadge.flag(String flagEmoji, {double size = 32.0, double fontSize = 18.0}) {
    return GlassyBadge(
      emoji: flagEmoji,
      size: size,
      emojiSize: fontSize,
      borderRadius: 10.0,
      glowColor: Colors.white.withValues(alpha: 0.1),
    );
  }

  /// Factory for glowing flame streak
  factory GlassyBadge.flame({double size = 28.0}) {
    return GlassyBadge(
      size: size,
      borderRadius: 99.0,
      glowColor: const Color(0xFFFF6B4A).withValues(alpha: 0.35),
      child: const Icon(
        Icons.local_fire_department_rounded,
        size: 16,
        color: Color(0xFFFF6B4A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.75);

    final defaultBorder = Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: 0.18)
          : Colors.white.withValues(alpha: 0.9),
      width: 1.0,
    );

    return Container(
      width: size > 0 ? size : null,
      height: size > 0 ? size : null,
      padding: padding ?? EdgeInsets.all(size > 0 ? 0 : 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? defaultBorder,
        boxShadow: [
          if (glowColor != null)
            BoxShadow(
              color: glowColor!,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: child ??
              (emoji != null
                  ? Text(
                      emoji!,
                      style: TextStyle(
                        fontSize: emojiSize,
                        height: 1.1,
                      ),
                    )
                  : const SizedBox.shrink()),
        ),
      ),
    );
  }
}
