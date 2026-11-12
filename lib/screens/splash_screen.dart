import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_profile_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/caloriq_logo.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ring1Controller;
  late AnimationController _ring2Controller;
  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _ring1Scale;
  late Animation<double> _ring1Opacity;
  late Animation<double> _ring2Scale;
  late Animation<double> _ring2Opacity;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;

  late Animation<double> _textOpacity;
  late Animation<double> _textTranslateY;

  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // 1. Pulsing rings animation controllers (3s duration each)
    _ring1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _ring2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    final Animatable<double> opacityTween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 70.0,
      ),
    ]);

    final Animatable<double> scaleTween = Tween<double>(begin: 0.85, end: 1.1);

    _ring1Scale = scaleTween.animate(_ring1Controller);
    _ring1Opacity = opacityTween.animate(_ring1Controller);

    _ring2Scale = scaleTween.animate(_ring2Controller);
    _ring2Opacity = opacityTween.animate(_ring2Controller);

    // Ring 1 starts immediately
    _ring1Controller.repeat();

    // Ring 2 starts with 0.6s delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _ring2Controller.repeat();
      }
    });

    // 2. Logo pop-in animation (0.9s duration, Cubic(0.2, 1.4, 0.4, 1.0))
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final logoCurve = CurvedAnimation(
      parent: _logoController,
      curve: const Cubic(0.2, 1.4, 0.4, 1.0),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(logoCurve);
    _logoRotation = Tween<double>(
      begin: -25 * math.pi / 180,
      end: 0.0,
    ).animate(logoCurve);

    _logoController.forward();

    // 3. Text fade-in animation (0.8s duration, 0.5s delay)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final textCurve = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(textCurve);
    _textTranslateY = Tween<double>(begin: 14.0, end: 0.0).animate(textCurve);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // 4. Auto-advance after 1.8 seconds total
    _timer = Timer(const Duration(milliseconds: 1800), () {
      _navigateNext();
    });
  }

  Future<void> _navigateNext() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _timer?.cancel();

    // Stop repeating animation controllers to prevent frame lag during transition
    _ring1Controller.stop();
    _ring2Controller.stop();

    final prefs = await SharedPreferences.getInstance();
    final isOnboardedPref = prefs.getBool('is_onboarded') ?? false;
    final hasProfileData = prefs.getString('user_profile_data') != null;

    if (!mounted) return;
    final userProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final bool hasProfile =
        isOnboardedPref || hasProfileData || userProvider.isOnboarded;

    // In debug/testing mode, always start from OnboardingScreen for convenience
    final Widget targetScreen =
        (!kDebugMode && hasProfile) ? const MainScreen() : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ring1Controller.dispose();
    _ring2Controller.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFC9F26B),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: _navigateNext,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 1 (340x340)
              Align(
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _ring1Controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _ring1Scale.value,
                      child: Opacity(
                        opacity: _ring1Opacity.value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 340,
                    height: 340,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(20, 20, 26, 0.12),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Ring 2 (540x540)
              Align(
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _ring2Controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _ring2Scale.value,
                      child: Opacity(
                        opacity: _ring2Opacity.value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 540,
                    height: 540,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(20, 20, 26, 0.12),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Center content Column
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated Logo with drop shadow
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(124 * (19 / 64)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4D14141A),
                            blurRadius: 30,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      child: const CaloriqLogo(
                        size: 124,
                      ),
                    ),
                  ),

                  // Text fade-in
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, _textTranslateY.value),
                          child: child,
                        ),
                      );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Caloriq',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                            color: AppTheme.ink,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Balance your burn. Master your plate.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xC014141A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
