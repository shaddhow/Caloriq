import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLime;
  final bool isGhost;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLime = false,
    this.isGhost = false,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color fgColor;

    if (isLime) {
      bgColor = AppTheme.lime;
      fgColor = AppTheme.ink;
    } else if (isGhost) {
      bgColor = isDark ? const Color(0xFF1A1A21) : AppTheme.card;
      fgColor = isDark ? Colors.white : AppTheme.ink;
    } else {
      bgColor = isDark ? Colors.white : AppTheme.ink;
      fgColor = isDark ? AppTheme.ink : Colors.white;
    }

    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.buttonsBorderRadius,
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
