import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/api_service.dart';
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
class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedLanguage;
  bool _isLoading = false;
  bool _isSaving = false;
  final ApiService _apiService = ApiService();
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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final remoteData = await _apiService.fetchUserProfile();
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString("language");
      if (mounted) {
        setState(() {
          _nameController.text = remoteData['name'] ??
              prefs.getString("name") ??
              widget.initialName ??
              "";
          _emailController.text = remoteData['email'] ??
              prefs.getString("email") ??
              widget.initialEmail ??
              "";
          _phoneController.text = remoteData['phone'] ??
              prefs.getString("phone") ??
              widget.initialPhone ??
              "";
          _selectedLanguage = savedLang ?? "en";
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading user data from API: $e");
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _nameController.text =
              prefs.getString("name") ?? widget.initialName ?? "";
          _emailController.text =
              prefs.getString("email") ?? widget.initialEmail ?? "";
          _phoneController.text =
              prefs.getString("phone") ?? widget.initialPhone ?? "";
          _selectedLanguage = prefs.getString("language") ?? "en";
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Failed to load profile from server. Data might be old."),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
  Future<void> _saveUserData() async {
    final l10n = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() => _isSaving = true);
      try {
        await _apiService.updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          language: _selectedLanguage!,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", _nameController.text.trim());
        await prefs.setString("phone", _phoneController.text.trim());
        await prefs.setString("language", _selectedLanguage!);
        if (_selectedLanguage != null) {
          FarmersApp.setLocale(context, Locale(_selectedLanguage!));
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n?.profileUpdated ?? "Profile updated successfully!",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        debugPrint("Error saving user data to API: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n?.profileUpdateFailed ?? "Failed to update profile.",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
            color: Colors.green.withAlpha(20),
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
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
                            color: Colors.white.withAlpha(230),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                                    color: Colors.black.withAlpha(38),
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
                                                color:
                                                    Colors.green.withAlpha(102),
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
                                              backgroundColor:
                                                  Colors.grey.shade50,
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
                                        _nameController.text.isEmpty
                                            ? "User"
                                            : _nameController.text,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _emailController.text.isEmpty
                                            ? "user@example.com"
                                            : _emailController.text,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 36),
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
                                      _buildCustomTextField(
                                        controller: _nameController,
                                        labelText: l10n?.name ?? "Name",
                                        prefixIcon:
                                            Icons.person_outline_rounded,
                                        validator: (value) => value == null ||
                                                value.isEmpty
                                            ? (l10n?.name ?? "Enter your name")
                                            : null,
                                      ),
                                      const SizedBox(height: 20),
                                      _buildCustomTextField(
                                        controller: _emailController,
                                        labelText: l10n?.email ?? "Email",
                                        prefixIcon: Icons.email_outlined,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        enabled:
                                            false,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return l10n?.email ??
                                                "Enter your email";
                                          }
                                          if (!RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                              .hasMatch(value)) {
                                            return l10n?.email ??
                                                "Enter a valid email";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      _buildCustomTextField(
                                        controller: _phoneController,
                                        labelText: l10n?.phone ?? "Phone",
                                        prefixIcon: Icons.phone_outlined,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? (l10n?.phone ??
                                                    "Enter your phone number")
                                                : null,
                                      ),
                                      const SizedBox(height: 32),
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
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withAlpha(20),
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
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 22),
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Text(
                                                          lang["label"]!,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() =>
                                                  _selectedLanguage = val);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: Container(
                                              margin: const EdgeInsets.all(12),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                  Icons.language_rounded,
                                                  color: Colors.green.shade600,
                                                  size: 22),
                                            ),
                                            labelText:
                                                l10n?.language ?? "Language",
                                            labelStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            filled: false,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.green.shade100,
                                                  width: 1.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.green.shade400,
                                                  width: 2.5),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              color:
                                                  Colors.green.withAlpha(102),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed:
                                              _isSaving ? null : _saveUserData,
                                          child: _isSaving
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 3,
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.white,
                                                        size: 24),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      l10n?.save ??
                                                          "Save Changes",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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