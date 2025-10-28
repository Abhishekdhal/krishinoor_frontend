// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// REMOVED: import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/splash_screen.dart';
import 'l10n/app_localizations.dart';

// --- NEW GLOBAL CONSTANT FOR BASE URL ---
// This will hold the Vercel URL loaded from the .env file.
String? kBaseUrl; 

Future<void> main() async {
  // Ensures all Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    // 1. Load the .env file
    await dotenv.load(fileName: ".env");
    debugPrint("✅ Loaded .env file");
    debugPrint("✅ Loaded .env file");
    
    // 2. Load the Vercel Base URL and store it globally
    kBaseUrl = dotenv.env['VERCEL_BASE_URL'];

    if (kBaseUrl == null) {
      debugPrint("❌ Could not find VERCEL_BASE_URL in .env file. API calls will likely fail.");
    } else {
      debugPrint("✅ Vercel Base URL loaded: $kBaseUrl");
    }

  } catch (e) {
    debugPrint("❌ Could not load .env file: $e");
  }

  // --- REMOVED SUPABASE INITIALIZATION ---
  // All Supabase.initialize logic has been deleted.
  // ----------------------------------------

  // Load saved language code from SharedPreferences
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

  /// Helper to change locale from anywhere in the app
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

  /// Update locale and save in SharedPreferences
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

      // Dynamic locale
      locale: _locale,

      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('ml'), // Malayalam
        Locale('or'), // Odia
      ],

      // Start app with SplashScreen
      home: const SplashScreen(),
    );
  }
}