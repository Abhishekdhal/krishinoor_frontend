import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'login_page.dart';

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

    // Navigate after animation
    Future.delayed(const Duration(seconds: 4), () async {
      if (!mounted) return;

      final currentUser = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = currentUser != null;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLoggedIn ? const HomePage() : const LoginPage(),
        ),
      );
    });
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
                        color: Colors.yellow.withOpacity(0.5),
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
                        const Color(0xFF9ACD32).withOpacity(0.3),
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
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF2ecc71)
                                        .withOpacity(0.4),
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
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                              color: Colors.white.withOpacity(0.8),
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
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                backgroundColor:
                                    Colors.white.withOpacity(0.3),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
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

// Custom painter for wheat pattern at bottom
class WheatPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDAA520).withOpacity(0.3)
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
          ..color = const Color(0xFFDAA520).withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(x + 3, size.height - 35),
        2,
        Paint()
          ..color = const Color(0xFFDAA520).withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}






// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'home_page.dart';
// import 'login_page.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
//     );

//     _controller.forward();

//     // Navigate after animation
//     Future.delayed(const Duration(seconds: 3), () async {
//       if (!mounted) return;

//       final currentUser = Supabase.instance.client.auth.currentUser;
//       final isLoggedIn = currentUser != null;

//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => isLoggedIn ? const HomePage() : const LoginPage(),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF0a192f),
//               Color(0xFF112240),
//               Color(0xFF1a365d),
//             ],
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: ScaleTransition(
//             scale: _scaleAnimation,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Your Logo
//                 Container(
//                   width: 160,
//                   height: 160,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF2ecc71),
//                         Color(0xFF27ae60),
//                         Color(0xFF229954),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(35),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.6),
//                         blurRadius: 50,
//                         offset: const Offset(0, 25),
//                       ),
//                       BoxShadow(
//                         color: const Color(0xFF2ecc71).withOpacity(0.4),
//                         blurRadius: 40,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(35),
//                     child: Image.asset(
//                       'assets/images/logo.png', // Your logo here
//                       width: 160,
//                       height: 160,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 50),

//                 // App Name
//                 ShaderMask(
//                   shaderCallback: (bounds) => const LinearGradient(
//                     colors: [
//                       Color(0xFF2ecc71),
//                       Color(0xFF27ae60),
//                       Color(0xFF3498db),
//                     ],
//                   ).createShader(bounds),
//                   child: const Text(
//                     'KRISHINOOR',
//                     style: TextStyle(
//                       fontSize: 56,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 7,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Tagline
//                 Text(
//                   'Smart Farming Solutions',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white.withOpacity(0.75),
//                     letterSpacing: 4,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//                 const SizedBox(height: 60),

//                 // Loading Indicator
//                 SizedBox(
//                   width: 260,
//                   child: Column(
//                     children: [
//                       Text(
//                         'LOADING',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white.withOpacity(0.5),
//                           letterSpacing: 3,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(2),
//                         child: LinearProgressIndicator(
//                           backgroundColor: Colors.white.withOpacity(0.1),
//                           valueColor: const AlwaysStoppedAnimation<Color>(
//                             Color(0xFF2ecc71),
//                           ),
//                           minHeight: 4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart'; // Required for auth check
// // // Corrected imports for files in the same 'screens' directory
// // import 'home_page.dart'; 
// // import 'login_page.dart'; 

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with TickerProviderStateMixin {
// //   final String fullText = "KRISHINOOR";
// //   String currentText = "";
// //   int _index = 0;
// //   Timer? _timer;

// //   late final AnimationController _imageController;
// //   late final Animation<Offset> _imageSlide;
// //   late final Animation<double> _imageFade;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _imageController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 800),
// //     );

// //     _imageSlide = Tween<Offset>(
// //       begin: const Offset(0, 0.3),
// //       end: Offset.zero,
// //     ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

// //     _imageFade = CurvedAnimation(
// //       parent: _imageController,
// //       curve: Curves.easeIn,
// //     );

// //     // Typewriter effect
// //     _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
// //       if (_index < fullText.length) {
// //         setState(() {
// //           currentText += fullText[_index];
// //           _index++;
// //         });
// //       } else {
// //         timer.cancel();
// //         _imageController.forward();

// //         // Navigate after short delay
// //         Future.delayed(const Duration(seconds: 2), () async {
// //           if (!mounted) return;

// //           // ⭐ Supabase Session Check: Check for an active user session
// //           final currentUser = Supabase.instance.client.auth.currentUser;
// //           final isLoggedIn = currentUser != null;

// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             if (!mounted) return;
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (_) => isLoggedIn ? const HomePage() : const LoginPage(),
// //               ),
// //             );
// //           });
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     _imageController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final double textSize = MediaQuery.of(context).size.width * 0.08 + 8;

// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         decoration: const BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage("assets/images/background.jpeg"), // make sure added in pubspec.yaml
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // App name typing animation
// //             Text(
// //               currentText,
// //               style: TextStyle(
// //                 fontSize: textSize,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //                 letterSpacing: 2,
// //                 shadows: const [
// //                   Shadow(
// //                     blurRadius: 8,
// //                     color: Colors.black54,
// //                     offset: Offset(2, 2),
// //                   ),
// //                 ],
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 30),

// //             // Logo animation
// //             FadeTransition(
// //               opacity: _imageFade,
// //               child: SlideTransition(
// //                 position: _imageSlide,
// //                 child: Image.asset(
// //                   'assets/images/farm2.png', // make sure added in pubspec.yaml
// //                   width: 160,
// //                   height: 160,
// //                   fit: BoxFit.contain,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
