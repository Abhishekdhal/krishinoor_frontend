import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      "2f184182c9504a3092a115647251509"; // Replace with your OpenWeatherMap API Key
  final String city =
      "Bhubaneswar"; // Change to your city, or make it dynamic later

  Future<Map<String, dynamic>> fetchWeather() async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
