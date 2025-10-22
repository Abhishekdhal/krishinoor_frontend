import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart'; 

// IMPORTANT: Replace with your actual path for localization
import '../l10n/app_localizations.dart'; 

// Imports for feature pages (using correct relative paths within 'screens')
import 'ai_bot_page.dart';
import 'supplements_page.dart';
import 'weather_page.dart';
import 'notice_board_page.dart';
import 'iot_farming_page.dart';
import 'soil_health_page.dart';
import 'market_price_page.dart';
import 'problem_upload_page.dart';
import 'feedback_page.dart';
import 'profile_page.dart';
import 'login_page.dart'; 

// --- ENHANCED THEME COLORS ---
const Color primaryGreen = Color(0xFF2E7D32); // Rich forest green
const Color lightGreen = Color(0xFF66BB6A); // Lighter green accent
const Color accentGold = Color(0xFFFFB300); // Warm gold accent
const Color backgroundWhite = Color(0xFFFAFAFA); // Clean white background
const Color cardBackground = Color(0xFFFFFFFF); // Pure white cards
const Color textDark = Color(0xFF1B5E20); // Dark green text
const Color textLight = Color(0xFF757575); // Light gray text
const Color shadowColor = Color(0x1A000000); // Subtle shadow

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? _name;
  String? _email;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Weather data variables
  String _temperature = "28°";
  String _weatherDescription = "Mostly Sunny";
  String _location = "Loading...";
  bool _isLoadingWeather = true;
  final String _apiKey = "2f184182c9504a3092a115647251509"; // Your WeatherAPI key

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeAnimations();
    _loadWeatherData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Loads weather data from WeatherAPI using location
  Future<void> _loadWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Try to get cached weather data first
      final cachedTemp = prefs.getString('cached_temperature');
      final cachedDesc = prefs.getString('cached_weather_description');
      final cachedLocation = prefs.getString('cached_location');
      final lastUpdate = prefs.getInt('weather_last_update') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      
      // If cache is less than 30 minutes old, use it
      if (cachedTemp != null && cachedDesc != null && 
          (currentTime - lastUpdate) < 1800000) { // 30 minutes
        setState(() {
          _temperature = cachedTemp;
          _weatherDescription = cachedDesc;
          _location = cachedLocation ?? "Current Location";
          _isLoadingWeather = false;
        });
        return;
      }
      
      // Get current location and fetch fresh weather data
      await _getCurrentLocationAndFetchWeather();
      
    } catch (e) {
      debugPrint("Weather loading error: $e");
      setState(() {
        _temperature = "N/A";
        _weatherDescription = "Unable to load";
        _location = "Weather data";
        _isLoadingWeather = false;
      });
    }
  }
  
  /// Get current location and fetch weather data
  Future<void> _getCurrentLocationAndFetchWeather() async {
    try {
      // Check location permission
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied) {
          // Use default location if permission denied
          await _fetchWeatherFromAPI("Bhubaneswar");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Use default location if permission denied forever
        await _fetchWeatherFromAPI("Bhubaneswar");
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Fetch weather using coordinates
      await _fetchWeatherFromAPI("${position.latitude},${position.longitude}");
      
    } catch (e) {
      debugPrint("Location error: $e");
      // Fallback to default city
      await _fetchWeatherFromAPI("Bhubaneswar");
    }
  }
  
  /// Fetch weather data from WeatherAPI
  Future<void> _fetchWeatherFromAPI(String query) async {
    try {
      final url = "http://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$query";
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          _temperature = "${data['current']['temp_c'].round()}°";
          _weatherDescription = data['current']['condition']['text'];
          _location = data['location']['name'];
          _isLoadingWeather = false;
        });
        
        // Cache the data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_temperature', _temperature);
        await prefs.setString('cached_weather_description', _weatherDescription);
        await prefs.setString('cached_location', _location);
        await prefs.setInt('weather_last_update', DateTime.now().millisecondsSinceEpoch);
        
      } else {
        throw Exception("Failed to load weather data: ${response.statusCode}");
      }
      
    } catch (e) {
      debugPrint("Weather API error: $e");
      setState(() {
        _temperature = "N/A";
        _weatherDescription = "Unable to load";
        _location = "Weather data";
        _isLoadingWeather = false;
      });
    }
  }
  /// Loads user data (name, email) directly from the active Supabase session.
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user != null) {
      final userEmail = user.email;
      final userName = user.userMetadata?['full_name'] as String?;

      setState(() {
        _name = userName; 
        _email = userEmail ?? "N/A";
      });
    }
  }

  /// Logs the user out from Supabase and clears local data.
  Future<void> _logout() async {
    if (!mounted) return;
    
    try {
      await Supabase.instance.client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (!mounted) return;
      
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const LoginPage()), 
        (route) => false
      );
    } catch (e) {
      debugPrint("Logout error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to log out, please try again."),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // --- Enhanced Feature Tile Widget ---
  Widget _buildFeatureTile(
      String name, IconData icon, Widget page, BuildContext context, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _fadeAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => page,
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 2,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cardBackground,
                          cardBackground.withOpacity(0.95),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with gradient background
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [lightGreen, primaryGreen],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon, 
                            size: 32, 
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Feature name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
    );
  }

  // --- Welcome Header Widget ---
  Widget _buildWelcomeHeader(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryGreen, lightGreen],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          InkWell(
            onTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
              if (updated == true) {
                _loadUserData();
              }
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: accentGold,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person, 
                color: Colors.white, 
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hello (_name ?? l10n.farmer),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.welcomeBack,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
    );
  }

  // --- Compact Weather and Market Row ---
  Widget _buildWeatherAndMarketRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Weather Card - Compact & Clickable
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () async {
                // Navigate to Weather Page
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeatherPage()),
                );
                // Refresh weather data when returning from weather page
                if (result == true || result == null) {
                  _loadWeatherData();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Temperature and Weather Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isLoadingWeather
                              ? Container(
                                  width: 60,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )
                              : Text(
                                  _temperature,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                          const SizedBox(height: 2),
                          _isLoadingWeather
                              ? Container(
                                  width: 80,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                )
                              : Text(
                                  _weatherDescription,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          Text(
                            "Today's Weather",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Weather Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _isLoadingWeather
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              _getWeatherIcon(_weatherDescription),
                              size: 24,
                              color: accentGold,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Market Alert Card - Compact
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: Colors.orange.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "3 New",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  Text(
                    "Market Alert",
                    style: TextStyle(
                      fontSize: 10,
                      color: textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get appropriate weather icon
  IconData _getWeatherIcon(String description) {
    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('sunny') || lowerDesc.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lowerDesc.contains('cloud')) {
      return Icons.wb_cloudy;
    } else if (lowerDesc.contains('rain')) {
      return Icons.umbrella;
    } else if (lowerDesc.contains('storm')) {
      return Icons.flash_on;
    } else if (lowerDesc.contains('snow')) {
      return Icons.ac_unit;
    } else {
      return Icons.wb_sunny; // default
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; 
    final screenWidth = MediaQuery.of(context).size.width;

    // Define the list of features for the GridView with better icons
    final List<Map<String, dynamic>> features = [
      {
        "name": l10n.supplements,
        "icon": Icons.local_pharmacy,
        "page": const SupplementsPage()
      },
      {
        "name": l10n.weather, 
        "icon": Icons.wb_sunny, 
        "page": const WeatherPage()
      },
      {
        "name": l10n.krishiMitra, 
        "icon": Icons.person_outline, 
        "page": const AIBotPage()
      },
      {
        "name": l10n.noticeBoard,
        "icon": Icons.announcement,
        "page": const NoticeBoardPage()
      },
      {
        "name": l10n.iotFarming,
        "icon": Icons.sensors,
        "page": const IoTFarmingPage()
      },
      {
        "name": l10n.soilHealth,
        "icon": Icons.eco,
        "page": const SoilHealthPage()
      },
      {
        "name": l10n.marketPrices,
        "icon": Icons.show_chart,
        "page": const MarketPricePage()
      },
      {
        "name": l10n.cropProblemDetector,
        "icon": Icons.bug_report,
        "page": const ProblemUploadPage()
      },
      {
        "name": l10n.feedback,
        "icon": Icons.rate_review,
        "page": const FeedbackPage()
      },
    ];

    return Scaffold(
      backgroundColor: backgroundWhite,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar - Compact
          SliverAppBar(
            expandedHeight: 110,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryGreen, lightGreen],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    // Logo with white circular background
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // App Name - Centered
                    Text(
                      l10n.appTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Remove default title since we have custom layout
            title: Container(),
            centerTitle: true,
          ),
          
          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Welcome Header
                _buildWelcomeHeader(l10n),
                
                // Weather and Market Row
                _buildWeatherAndMarketRow(),
                
                // Section Title
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Farm Tools & Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                
                // Features Grid
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600 ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      return _buildFeatureTile(
                        feature["name"], 
                        feature["icon"], 
                        feature["page"], 
                        context,
                        index,
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [lightGreen, primaryGreen],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Text(
            l10n.askKrishiMitra, 
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const AIBotPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    )),
                    child: child,
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.person_outline, color: Colors.white),
        ),
      ),
    );
  }
}