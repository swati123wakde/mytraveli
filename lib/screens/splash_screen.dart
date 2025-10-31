import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../providers/device_provider.dart';
import '../widgets/gradient_background.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo scale animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start animations
    _logoController.forward();
    Timer(const Duration(milliseconds: 500), () {
      _fadeController.forward();
    });

    // Register device and navigate
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
      await deviceProvider.registerDevice();

      // Wait for animations to complete (fixed the delay duration)
      await Future.delayed(const Duration(milliseconds: 250));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      // Even on error, navigate after delay
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important: Make scaffold background transparent
        body: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.purple.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  ScaleTransition(
                    scale: _logoAnimation,
                    child:   Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentPurple.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.hotel_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),



                ],
              ),
            ),

            // Footer
          ],
        ),
      ),
    );
  }
}