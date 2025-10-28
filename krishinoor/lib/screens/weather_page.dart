import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with TickerProviderStateMixin {
  String? city;
  String apiKey = "2f184182c9504a3092a115647251509";
  Map<String, dynamic>? weatherData;
  String? errorMessage;
  
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getCurrentLocationAndFetchWeather();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocationAndFetchWeather() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied) {
          setState(() {
            errorMessage = "Location permission denied";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = "Location permission denied forever";
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
      });
    }
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    final url =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=7&aqi=no&alerts=no";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          errorMessage = null;
        });
        _animationController.forward();
        _cardAnimationController.forward();
      } else {
        setState(() {
          errorMessage = "Failed to load weather data";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
      });
    }
  }

  String getFarmingTipFromData(Map<String, dynamic> data, AppLocalizations l10n) {
    final condition = data['condition']['text'].toString().toLowerCase();
    final temp = data['temp_c'] ?? data['avgtemp_c'] ?? 0;
    final humidity = data['humidity'] ?? data['avghumidity'] ?? 60;

    if (condition.contains("rain")) {
      return l10n.farmingTip_rain;
    } else if (condition.contains("sunny") || condition.contains("clear")) {
      if (temp > 32) {
        return l10n.farmingTip_hot;
      } else {
        return l10n.farmingTip_sunny;
      }
    } else if (condition.contains("cloud")) {
      return l10n.farmingTip_cloudy;
    } else if (humidity > 80) {
      return l10n.farmingTip_humidity;
    } else {
      return l10n.farmingTip_normal;
    }
  }

  Color _getGradientColor() {
    if (weatherData == null) return const Color(0xFF4facfe);
    
    final condition = weatherData!['current']['condition']['text'].toLowerCase();
    final isDay = weatherData!['current']['is_day'] == 1;
    
    if (condition.contains('rain') || condition.contains('storm')) {
      return isDay ? const Color(0xFF536976) : const Color(0xFF292E49);
    } else if (condition.contains('cloud')) {
      return isDay ? const Color(0xFF757F9A) : const Color(0xFF485563);
    } else if (condition.contains('snow')) {
      return const Color(0xFFE6DEDD);
    } else if (condition.contains('clear') || condition.contains('sunny')) {
      return isDay ? const Color(0xFFFFB75E) : const Color(0xFF283048);
    }
    return isDay ? const Color(0xFF4facfe) : const Color(0xFF434343);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.weatherTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getGradientColor(),
              _getGradientColor().withAlpha(204),
              const Color(0xFF00f2fe),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: weatherData == null
            ? _buildLoadingState()
            : FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Current Weather Card
                              SlideTransition(
                                position: _slideAnimation,
                                child: _buildCurrentWeatherCard(l10n),
                              ),
                              const SizedBox(height: 24),
                              
                              // Weather Details Grid
                              SlideTransition(
                                position: _slideAnimation,
                                child: _buildWeatherDetailsGrid(),
                              ),
                              const SizedBox(height: 24),
                              
                              // 7-Day Forecast
                              _buildForecastSection(l10n),
                              const SizedBox(height: 24),
                              
                              // Hourly Forecast
                              _buildHourlyForecastSection(l10n),
                              const SizedBox(height: 100),
                            ],
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

  Widget _buildLoadingState() {
    return Center(
      child: errorMessage != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _getCurrentLocationAndFetchWeather,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withAlpha(51),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(26),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Fetching weather data...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCurrentWeatherCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withAlpha(51),
            Colors.white.withAlpha(26),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withAlpha(51),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Location
          Text(
            weatherData!['location']['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weatherData!['location']['country'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha(204),
            ),
          ),
          const SizedBox(height: 20),
          
          // Weather Icon and Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "https:${weatherData!['current']['condition']['icon']}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              
              // Temperature
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${weatherData!['current']['temp_c'].round()}°",
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    weatherData!['current']['condition']['text'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withAlpha(230),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Feels like temperature
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Feels like ${weatherData!['current']['feelslike_c'].round()}°",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(204),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildWeatherDetailCard(
          "Humidity",
          "${weatherData!['current']['humidity']}%",
          Icons.water_drop,
          Colors.blue,
        ),
        _buildWeatherDetailCard(
          "Wind Speed",
          "${weatherData!['current']['wind_kph']} km/h",
          Icons.air,
          Colors.teal,
        ),
        _buildWeatherDetailCard(
          "Pressure",
          "${weatherData!['current']['pressure_mb']} mb",
          Icons.compress,
          Colors.orange,
        ),
        _buildWeatherDetailCard(
          "UV Index",
          "${weatherData!['current']['uv']}",
          Icons.wb_sunny,
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildWeatherDetailCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: color.withAlpha(204),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withAlpha(178),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "7-Day Forecast",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(230),
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData!['forecast']['forecastday'].length,
            itemBuilder: (context, index) {
              final day = weatherData!['forecast']['forecastday'][index];
              final date = day['date'];
              final icon = day['day']['condition']['icon'];
              final maxTemp = day['day']['maxtemp_c'].round();
              final minTemp = day['day']['mintemp_c'].round();

              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          "https:$icon",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$maxTemp°",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$minTemp°",
                          style: TextStyle(
                            color: Colors.white.withAlpha(153),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        getFarmingTipFromData(day['day'], l10n),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withAlpha(178),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecastSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "Hourly Forecast (Today)",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(230),
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData!['forecast']['forecastday'][0]['hour'].length,
            itemBuilder: (context, index) {
              final hour = weatherData!['forecast']['forecastday'][0]['hour'][index];
              final time = hour['time'].toString().split(" ")[1];
              final icon = hour['condition']['icon'];
              final temp = hour['temp_c'].round();

              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time.substring(0, 5),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(204),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      "https:$icon",
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$temp°",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final now = DateTime.now();
    
    if (dateTime.day == now.day) {
      return "Today";
    } else if (dateTime.day == now.day + 1) {
      return "Tomorrow";
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${dateTime.day} ${months[dateTime.month - 1]}";
    }
  }
}