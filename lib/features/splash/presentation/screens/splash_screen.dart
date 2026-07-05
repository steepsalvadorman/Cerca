import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../cerca/presentation/widgets/cerca_logo_mark.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';

/// Animated brand intro: the CodeCraftPeru studio mark hands off to the
/// Cerca mark, then auto-advances to Login. Matches the source design's
/// staggered CSS keyframe timings, reimplemented as a short Timer
/// sequence driving Flutter's implicit animations.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _craftFadingOut = false;
  bool _cercaEntered = false;
  bool _showFooter = false;
  bool _showTitle = false;
  bool _showTagline = false;
  bool _navigated = false;

  late final AnimationController _breathe;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      lowerBound: 1.0,
      upperBound: 1.05,
    );

    _schedule(1000, () => setState(() {
          _craftFadingOut = true;
          _cercaEntered = true;
        }));
    _schedule(1500, () => setState(() => _showFooter = true));
    _schedule(1700, () => _breathe.repeat(reverse: true));
    _schedule(1800, () => setState(() => _showTitle = true));
    _schedule(2050, () => setState(() => _showTagline = true));
    _schedule(3200, _goLogin);
  }

  void _schedule(int milliseconds, VoidCallback callback) {
    _timers.add(Timer(Duration(milliseconds: milliseconds), callback));
  }

  void _goLogin() {
    if (_navigated || !mounted) return;
    _navigated = true;
    for (final timer in _timers) {
      timer.cancel();
    }
    context.go(RoutePaths.login);
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goLogin,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.4),
              radius: 1.1,
              colors: [Color(0xFF241417), Color(0xFF150D0E), Color(0xFF0E0A09)],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: _craftFadingOut ? 0 : 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          child: AnimatedScale(
                            scale: _craftFadingOut ? 0.65 : 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                            child: const CodeCraftLogoMark(size: 82),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _cercaEntered ? 1 : 0,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutBack,
                          child: AnimatedScale(
                            scale: _cercaEntered ? 1 : 0.5,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOutBack,
                            child: AnimatedBuilder(
                              animation: _breathe,
                              builder: (context, child) => Transform.scale(scale: _breathe.value, child: child),
                              child: const CercaLogoMark(
                                size: 98,
                                lightStroke: Color(0xFFD1717C),
                                accent: Color(0xFFE4939C),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedOpacity(
                    opacity: _showTitle ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    child: Text('Cerca', style: CercaText.lora(fontSize: 30, color: const Color(0xFFF3ECE7))),
                  ),
                  const SizedBox(height: 6),
                  AnimatedOpacity(
                    opacity: _showTagline ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Técnicos verificados, cerca de ti',
                      style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFFB7A9A3)),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 34,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _showFooter ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CodeCraftLogoMark(size: 16),
                      const SizedBox(width: 7),
                      Text(
                        'Creado por CodeCraftPeru',
                        style: CercaText.sora(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF8C7D77)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
