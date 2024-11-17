import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config/assets.dart';
import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000), _navigateToNextScreen);
    super.initState();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainNavScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.images.logoWithText,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fadeIn(
                    duration: 1000.ms,
                    curve: Curves.easeOut,
                  )
                  .scaleXY(
                    begin: 0.8,
                    end: 1,
                    duration: 1500.ms,
                    curve: Curves.easeOutExpo,
                  )
                  .then()
                  .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.2),
                  )
                  .animate(delay: 200.ms)
                  .moveY(
                    begin: 10,
                    end: -10,
                    duration: 2000.ms,
                    curve: Curves.easeInOutSine,
                  ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
