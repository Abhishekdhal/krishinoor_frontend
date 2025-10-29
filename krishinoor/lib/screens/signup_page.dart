// lib/screens/signup_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// REMOVED: import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/api_service.dart'; // 💡 NEW: Import the custom API service
import 'home_page.dart';
import 'login_page.dart';
import 'package:flutter/foundation.dart'; // Import kDebugMode

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedLanguage;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // 💡 NEW: Initialize API service
  final ApiService _apiService = ApiService();

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> languages = [
    {"code": "en", "label": "English"},
    {"code": "hi", "label": "Hindi"},
    {"code": "ml", "label": "Malyalam"},
    {"code": "or", "label": "Odia"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _setupAnimations();
    // ⚠️ MIGRATION NOTE: Supabase Auth Listener is removed.
    // We only check for navigation after a successful registration API call.
    // _setupAuthListener(); // REMOVED
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  // REMOVED: Supabase Auth Listener is no longer functional.
  /*
  void _setupAuthListener() {
    // Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    //   final session = data.session;
    //   if (session != null && mounted) {
    //     // Successfully signed in with Google
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const HomePage()),
    //     );
    //   }
    // });
  }
  */

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLangCode = prefs.getString("language");

    setState(() {
      _selectedLanguage = savedLangCode;
    });

    if (savedLangCode != null) {
      if (mounted) {
        FarmersApp.setLocale(context, Locale(savedLangCode));
      }
    }
  }

  /// 💡 MIGRATED: Replaced Supabase sign-up and profile update with a single API call.
  Future<void> _signUp() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    // Check all required fields (now properly cleaned of hidden characters)
    if (_emailController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedLanguage == null) {
      _showCustomSnackBar(l10n.fillAllFields, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 💥 FIXED: Passes the 'language' parameter and uses 'name' key (matching API service)
      await _apiService.registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController
            .text, // Changed parameter name to match ApiService/Backend
        phone: _phoneController.text,
        language: _selectedLanguage!, // PASSING LANGUAGE
      );

      // Save selected language locally upon successful signup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("language", _selectedLanguage!);

      if (!mounted) return;

      _showCustomSnackBar(l10n.signupSuccess, isError: false);

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      // 🔑 Improved error display logic
      final errorMessage = e.toString().contains("Exception:")
          ? e.toString().split("Exception:")[1].trim()
          : e.toString();

      _showCustomSnackBar("${l10n.signupFailed}: $errorMessage", isError: true);
      if (kDebugMode) {
        debugPrint("Sign Up Error: $e");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// ⚠️ MIGRATED/TEMPORARILY REMOVED: Google OAuth sign-in.
  /// This must be entirely re-architected on the Vercel backend side.
  Future<void> _signUpWithGoogle() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    _showCustomSnackBar(
        "Google Sign-Up is not yet configured for Vercel backend.",
        isError: true);

    // Original logic is removed as it relies heavily on Supabase's built-in SDK.
    /*
    setState(() => _isLoading = true);
    try {
      final result = await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterdemo://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      // ... (rest of the original OAuth logic)
    } on AuthException catch (error) {
      // ...
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    */
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    // ... (Snackbar implementation remains the same)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message, style: const TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  // --- Widget Builders (Skipped as they are unchanged) ---
  Widget _buildGradientBackground() {
    // ... (unchanged)
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade300,
            Colors.green.shade600,
            Colors.teal.shade700,
            Colors.green.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withAlpha(26),
              Colors.transparent,
              Colors.black.withAlpha(26),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    // ... (unchanged)
    return Stack(
      children: [
        Positioned(
          top: 60,
          right: 25,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(26),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 80,
          left: 20,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value * 0.8,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(20),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    // ... (unchanged)
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: Colors.green.shade600, size: 20),
          suffixIcon: suffixIcon,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.green.shade700, fontSize: 13),
          filled: true,
          fillColor: Colors.white.withAlpha(230),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade600, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required List<Color> colors,
    IconData? icon,
    Color textColor = Colors.white,
  }) {
    // ... (unchanged)
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.first.withAlpha(76),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: textColor, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildFloatingElements(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: Card(
                          color: Colors.white.withAlpha(242),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 15,
                          shadowColor: Colors.black26,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withAlpha(230),
                                  Colors.white.withAlpha(242),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Logo, Title, Message (Skipped code for brevity)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade400,
                                          Colors.green.shade600,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withAlpha(76),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Colors.green.shade700,
                                        Colors.teal.shade600
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      l10n.signup,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  const Text(
                                    "Create your farmer's account",
                                    style: TextStyle(
                                      color: Color(
                                          0xFF757575), // Colors.grey[600] equivalent
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),

                                  // Name Field
                                  _buildCustomTextField(
                                    controller: _nameController,
                                    labelText: l10n.name,
                                    prefixIcon: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 10),

                                  // Email Field
                                  _buildCustomTextField(
                                    controller: _emailController,
                                    labelText: l10n.email,
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 10),

                                  // Phone Field
                                  _buildCustomTextField(
                                    controller: _phoneController,
                                    labelText: l10n.phone,
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 10),

                                  // Password Field
                                  _buildCustomTextField(
                                    controller: _passwordController,
                                    labelText: l10n.password,
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.green.shade600,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Language Dropdown
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(20),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: _selectedLanguage,
                                      items: languages
                                          .map((lang) => DropdownMenuItem(
                                                value: lang["code"],
                                                child: Text(lang["label"]!,
                                                    style: const TextStyle(
                                                        fontSize: 14)),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(
                                              () => _selectedLanguage = val);
                                          FarmersApp.setLocale(
                                              context, Locale(val));
                                        }
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.language,
                                            color: Colors.green.shade600,
                                            size: 20),
                                        labelText: l10n.language,
                                        labelStyle: TextStyle(
                                            color: Colors.green.shade700,
                                            fontSize: 13),
                                        filled: true,
                                        fillColor: Colors.white.withAlpha(230),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.green.shade200,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.green.shade600,
                                              width: 1.5),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Sign Up Button
                                  _buildGradientButton(
                                    text: l10n.signup,
                                    onPressed: _signUp,
                                    colors: [
                                      Colors.green.shade500,
                                      Colors.green.shade800
                                    ],
                                    icon: Icons.person_add_rounded,
                                  ),
                                  const SizedBox(height: 16),

                                  // OR Separator (Skipped code for brevity)
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade400)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          l10n.or,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade400)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Google Sign Up Button
                                  Container(
                                    width: double.infinity,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withAlpha(38),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          _isLoading ? null : _signUpWithGoogle,
                                      icon: _isLoading
                                          ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : Image.asset(
                                              'assets/images/google.png',
                                              height: 18,
                                              width: 18,
                                            ),
                                      label: const Text(
                                        "Sign up with Google",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.grey.shade800,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Login Link
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginPage(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.alreadyHaveAccount,
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
