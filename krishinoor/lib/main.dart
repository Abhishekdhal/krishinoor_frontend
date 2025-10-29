import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';
import 'l10n/app_localizations.dart';
String? kBaseUrl;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ Loaded .env file");
    debugPrint("✅ Loaded .env file");
    kBaseUrl = dotenv.env['VERCEL_BASE_URL'];
    if (kBaseUrl == null) {
      debugPrint(
          "❌ Could not find VERCEL_BASE_URL in .env file. API calls will likely fail.");
    } else {
      debugPrint("✅ Vercel Base URL loaded: $kBaseUrl");
    }
  } catch (e) {
    debugPrint("❌ Could not load .env file: $e");
  }
  final prefs = await SharedPreferences.getInstance();
  final savedLangCode = prefs.getString("language");
  final startLocale = savedLangCode != null ? Locale(savedLangCode) : null;
  runApp(FarmersApp(startLocale: startLocale));
}
class FarmersApp extends StatefulWidget {
  final Locale? startLocale;
  const FarmersApp({super.key, this.startLocale});
  @override
  State<FarmersApp> createState() => _FarmersAppState();
  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_FarmersAppState>();
    state?.setLocale(locale);
  }
}
class _FarmersAppState extends State<FarmersApp> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
    _locale = widget.startLocale;
  }
  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", locale.languageCode);
    setState(() => _locale = locale);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KRISHINOOR",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ml'),
        Locale('or'),
      ],
      home: const SplashScreen(),
    );
  }
}