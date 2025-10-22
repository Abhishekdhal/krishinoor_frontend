import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';
import '../main.dart'; // for FarmersApp.setLocale

class ProfilePage extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  final String? initialPhone;

  const ProfilePage({
    super.key,
    this.initialName,
    this.initialEmail,
    this.initialPhone,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedLanguage;
  bool _isLoading = false;
  bool _isSaving = false;

  late AnimationController _animationController;
  late AnimationController _avatarController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _avatarPulse;

  final List<Map<String, String>> languages = [
    {"code": "en", "label": "English", "flag": "🇬🇧"},
    {"code": "hi", "label": "Hindi", "flag": "🇮🇳"},
    {"code": "ml", "label": "Malyalam", "flag": "🇮🇳"},
    {"code": "or", "label": "Odia", "flag": "🇮🇳"},
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    _avatarPulse = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        if (user != null) {
          _nameController.text = user.userMetadata?['full_name'] ?? 
                                 prefs.getString("name") ?? 
                                 widget.initialName ?? "";
          
          _emailController.text = user.email ?? 
                                 prefs.getString("email") ?? 
                                 widget.initialEmail ?? "";
          
          _phoneController.text = user.userMetadata?['phone'] ?? 
                                 prefs.getString("phone") ?? 
                                 widget.initialPhone ?? "";
        } else {
          _nameController.text = prefs.getString("name") ?? widget.initialName ?? "";
          _emailController.text = prefs.getString("email") ?? widget.initialEmail ?? "";
          _phoneController.text = prefs.getString("phone") ?? widget.initialPhone ?? "";
        }
        
        _selectedLanguage = prefs.getString("language") ?? "en";
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading user data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", _nameController.text.trim());
        await prefs.setString("email", _emailController.text.trim());
        await prefs.setString("phone", _phoneController.text.trim());
        await prefs.setString("language", _selectedLanguage!);

        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          await Supabase.instance.client.auth.updateUser(
            UserAttributes(
              email: _emailController.text.trim(),
              data: {
                'full_name': _nameController.text.trim(),
                'phone': _phoneController.text.trim(),
              },
            ),
          );
        }

        FarmersApp.setLocale(context, Locale(_selectedLanguage!));

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)?.profileUpdated ?? "Profile updated successfully!",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            duration: const Duration(seconds: 2),
          ),
        );
        
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });
        
      } catch (e) {
        debugPrint("Error saving user data: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Failed to update profile: ${e.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: enabled ? Colors.white : Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        enabled: enabled,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: enabled ? Colors.grey.shade800 : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(prefixIcon, color: Colors.green.shade600, size: 22),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.green.shade100, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.green.shade400, width: 2.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.green.shade600,
              Colors.green.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.profile ?? "Profile",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Manage your information",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CircularProgressIndicator(
                            color: Colors.green.shade600,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(28.0),
                                  child: Column(
                                    children: [
                                      // Enhanced Profile Avatar
                                      ScaleTransition(
                                        scale: _avatarPulse,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.green.shade300,
                                                Colors.green.shade600,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green.withOpacity(0.4),
                                                blurRadius: 25,
                                                offset: const Offset(0, 10),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: CircleAvatar(
                                              radius: 58,
                                              backgroundColor: Colors.grey.shade50,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  "assets/images/logo.png",
                                                  height: 85,
                                                  width: 85,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _nameController.text.isEmpty ? "User" : _nameController.text,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _emailController.text.isEmpty ? "user@example.com" : _emailController.text,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 36),

                                      // Section Header
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "PERSONAL INFORMATION",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Name Field
                                      _buildCustomTextField(
                                        controller: _nameController,
                                        labelText: l10n?.name ?? "Name",
                                        prefixIcon: Icons.person_outline_rounded,
                                        validator: (value) =>
                                            value == null || value.isEmpty 
                                                ? (l10n?.name ?? "Enter your name") 
                                                : null,
                                      ),
                                      const SizedBox(height: 20),

                                      // Email Field
                                      _buildCustomTextField(
                                        controller: _emailController,
                                        labelText: l10n?.email ?? "Email",
                                        prefixIcon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
                                        enabled: false,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return l10n?.email ?? "Enter your email";
                                          }
                                          if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                                            return l10n?.email ?? "Enter a valid email";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Phone Field
                                      _buildCustomTextField(
                                        controller: _phoneController,
                                        labelText: l10n?.phone ?? "Phone",
                                        prefixIcon: Icons.phone_outlined,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) => value == null || value.isEmpty
                                            ? (l10n?.phone ?? "Enter your phone number")
                                            : null,
                                      ),
                                      const SizedBox(height: 32),

                                      // Section Header
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "PREFERENCES",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Enhanced Language Dropdown
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.08),
                                              blurRadius: 20,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: _selectedLanguage,
                                          items: languages
                                              .map((lang) => DropdownMenuItem(
                                                    value: lang["code"],
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          lang["flag"]!,
                                                          style: const TextStyle(fontSize: 22),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                          lang["label"]!,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() => _selectedLanguage = val);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Container(
                                              margin: const EdgeInsets.all(12),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(Icons.language_rounded, color: Colors.green.shade600, size: 22),
                                            ),
                                            labelText: l10n?.language ?? "Language",
                                            labelStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            filled: false,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide(color: Colors.green.shade100, width: 1.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide(color: Colors.green.shade400, width: 2.5),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),

                                      // Enhanced Save Button
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.green.shade500,
                                              Colors.green.shade700,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.4),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: _isSaving ? null : _saveUserData,
                                          child: _isSaving
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 3,
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      l10n?.save ?? "Save Changes",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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