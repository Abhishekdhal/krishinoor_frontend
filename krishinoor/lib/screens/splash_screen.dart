// lib/screens/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_page.dart';
import 'login_page.dart';

// Helper for Secure Storage, mirrored from api_service.dart for encapsulation
const _storage = FlutterSecureStorage();
const String _kTokenKey = 'jwt_token';
Future<String?> _getToken() => _storage.read(key: _kTokenKey);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // 💡 REVISED: Call the async check immediately, but allow animation time.
    _checkSessionAndNavigate(const Duration(seconds: 4));
  }

  // 💡 NEW HELPER FUNCTION for clarity
  Future<void> _checkSessionAndNavigate(Duration delay) async {
    await Future.delayed(delay); // Wait for animation delay

    if (!mounted) return;

    try {
      // Check for the stored JWT token
      final token = await _getToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLoggedIn ? const HomePage() : const LoginPage(),
        ),
      );
    } catch (e) {
      debugPrint("Error reading token/navigating: $e");
      // Fallback: If secure storage fails (the 'NotInitializedError'), default to login.
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue
              Color(0xFFB0E0E6), // Light sky blue
              Color(0xFFF0E68C), // Khaki (horizon)
              Color(0xFF9ACD32), // Yellow green (field)
              Color(0xFF6B8E23), // Olive drab (field)
            ],
            stops: [0.0, 0.3, 0.5, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              top: 60,
              right: 40,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFD700),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withAlpha(128),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom field decoration
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF9ACD32).withAlpha(76),
                        const Color(0xFF6B8E23),
                        const Color(0xFF556B2F),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: WheatPatternPainter(),
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with clear white background
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(76),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                  BoxShadow(
                                    color:
                                        const Color(0xFF2ecc71).withAlpha(102),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFF2ecc71),
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),

                    // App Name with farming colors
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF2ecc71), // Green
                          Color(0xFF27ae60), // Dark green
                          Color(0xFF6B8E23), // Olive
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'KRISHINOOR',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 6,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Tagline
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Smart Farming Solutions',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2ecc71),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Loading Indicator
                    SizedBox(
                      width: 240,
                      child: Column(
                        children: [
                          Text(
                            'LOADING',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(204),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white.withAlpha(76),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2ecc71),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for wheat pattern at bottom (unchanged)
class WheatPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDAA520).withAlpha(76)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw wheat stalks
    for (double x = 0; x < size.width; x += 30) {
      final path = Path();
      path.moveTo(x, size.height);
      path.lineTo(x, size.height - 40);

      // Wheat grain
      canvas.drawCircle(
        Offset(x - 3, size.height - 35),
        2,
        Paint()
          ..color = const Color(0xFFDAA520).withAlpha(128)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(x + 3, size.height - 35),
        2,
        Paint()
          ..color = const Color(0xFFDAA520).withAlpha(128)
          ..style = PaintingStyle.fill,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
