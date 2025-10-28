import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_or.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
    Locale('or')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KRISHINOOR'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @authMessage.
  ///
  /// In en, this message translates to:
  /// **'Securely login to your account'**
  String get authMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get language;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful!'**
  String get signupSuccess;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get signupFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Farmers of India'**
  String get homeTitle;

  /// No description provided for @supplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get supplements;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @aiBot.
  ///
  /// In en, this message translates to:
  /// **'AI Bot'**
  String get aiBot;

  /// No description provided for @noticeBoard.
  ///
  /// In en, this message translates to:
  /// **'Notice Board'**
  String get noticeBoard;

  /// No description provided for @iotFarming.
  ///
  /// In en, this message translates to:
  /// **'IoT Farming'**
  String get iotFarming;

  /// No description provided for @soilHealth.
  ///
  /// In en, this message translates to:
  /// **'Soil Health'**
  String get soilHealth;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @cropProblemDetector.
  ///
  /// In en, this message translates to:
  /// **'Crop Problem Detector'**
  String get cropProblemDetector;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @askAIBot.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Bot'**
  String get askAIBot;

  /// No description provided for @soilHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Fertility Analyzer'**
  String get soilHealthTitle;

  /// No description provided for @enterValues.
  ///
  /// In en, this message translates to:
  /// **'🌱 Enter Soil Test Values'**
  String get enterValues;

  /// No description provided for @phLabel.
  ///
  /// In en, this message translates to:
  /// **'Soil pH (e.g., 6.5)'**
  String get phLabel;

  /// No description provided for @nLabel.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (0-100)'**
  String get nLabel;

  /// No description provided for @pLabel.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (0-100)'**
  String get pLabel;

  /// No description provided for @kLabel.
  ///
  /// In en, this message translates to:
  /// **'Potassium (0-100)'**
  String get kLabel;

  /// No description provided for @analyzeButton.
  ///
  /// In en, this message translates to:
  /// **'Analyze Soil'**
  String get analyzeButton;

  /// No description provided for @bestPractices.
  ///
  /// In en, this message translates to:
  /// **'✅ Best Practices'**
  String get bestPractices;

  /// No description provided for @practice1.
  ///
  /// In en, this message translates to:
  /// **'Use organic manure to improve soil structure.'**
  String get practice1;

  /// No description provided for @practice2.
  ///
  /// In en, this message translates to:
  /// **'Rotate crops to maintain fertility.'**
  String get practice2;

  /// No description provided for @practice3.
  ///
  /// In en, this message translates to:
  /// **'Avoid excessive use of chemical fertilizers.'**
  String get practice3;

  /// No description provided for @practice4.
  ///
  /// In en, this message translates to:
  /// **'Test soil every 2-3 years for better planning.'**
  String get practice4;

  /// No description provided for @invalidValues.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numeric values.'**
  String get invalidValues;

  /// No description provided for @acidicSoil.
  ///
  /// In en, this message translates to:
  /// **'Soil is acidic.\nAdd lime.\nCrops: Potato, Pineapple, Rice.'**
  String get acidicSoil;

  /// No description provided for @alkalineSoil.
  ///
  /// In en, this message translates to:
  /// **'Soil is alkaline.\nAdd gypsum/organic matter.\nCrops: Cotton, Sugar beet, Barley.'**
  String get alkalineSoil;

  /// No description provided for @goodSoil.
  ///
  /// In en, this message translates to:
  /// **'Soil pH is good for most crops.'**
  String get goodSoil;

  /// No description provided for @addN.
  ///
  /// In en, this message translates to:
  /// **'Add Urea (Nitrogen).'**
  String get addN;

  /// No description provided for @addP.
  ///
  /// In en, this message translates to:
  /// **'Add DAP (Phosphorus).'**
  String get addP;

  /// No description provided for @addK.
  ///
  /// In en, this message translates to:
  /// **'Add MOP (Potassium).'**
  String get addK;

  /// No description provided for @balancedNPK.
  ///
  /// In en, this message translates to:
  /// **'NPK levels are balanced. Maintain with compost.'**
  String get balancedNPK;

  /// No description provided for @marketTitle.
  ///
  /// In en, this message translates to:
  /// **'🌾 Market Prices'**
  String get marketTitle;

  /// No description provided for @tabFertilizers.
  ///
  /// In en, this message translates to:
  /// **'Fertilizers'**
  String get tabFertilizers;

  /// No description provided for @tabSeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get tabSeeds;

  /// No description provided for @tabSprays.
  ///
  /// In en, this message translates to:
  /// **'Sprays'**
  String get tabSprays;

  /// No description provided for @tabNutrients.
  ///
  /// In en, this message translates to:
  /// **'Nutrients'**
  String get tabNutrients;

  /// No description provided for @bestLabel.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestLabel;

  /// No description provided for @amazon.
  ///
  /// In en, this message translates to:
  /// **'Amazon'**
  String get amazon;

  /// No description provided for @flipkart.
  ///
  /// In en, this message translates to:
  /// **'Flipkart'**
  String get flipkart;

  /// No description provided for @mandi.
  ///
  /// In en, this message translates to:
  /// **'Mandi'**
  String get mandi;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day {value}'**
  String day(Object value);

  /// No description provided for @iotTitle.
  ///
  /// In en, this message translates to:
  /// **'IoT-based Farming'**
  String get iotTitle;

  /// No description provided for @iotDescription.
  ///
  /// In en, this message translates to:
  /// **'Soil suitability analysis using IoT devices.'**
  String get iotDescription;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'💬 Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackHeader.
  ///
  /// In en, this message translates to:
  /// **'We value your feedback 💚'**
  String get feedbackHeader;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get yourFeedback;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'📷 No image selected'**
  String get noImage;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'🎉 Thank You!'**
  String get thankYou;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been submitted successfully.\nWe appreciate your time 💚'**
  String get thankYouMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please enter name and feedback'**
  String get pleaseEnter;

  /// No description provided for @problemDetectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Problem Detector'**
  String get problemDetectorTitle;

  /// No description provided for @problemDescription.
  ///
  /// In en, this message translates to:
  /// **'Problem Description'**
  String get problemDescription;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @takeChooseImage.
  ///
  /// In en, this message translates to:
  /// **'Take/Choose Image'**
  String get takeChooseImage;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD'**
  String get upload;

  /// No description provided for @addDescriptionAndImage.
  ///
  /// In en, this message translates to:
  /// **'Please add description and image ❌'**
  String get addDescriptionAndImage;

  /// No description provided for @problemReportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Problem reported successfully ✅'**
  String get problemReportedSuccess;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error ❌ '**
  String get error;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @farmingTip_rain.
  ///
  /// In en, this message translates to:
  /// **'🌧 Good for paddy and rice crops. Avoid pesticide spraying today.'**
  String get farmingTip_rain;

  /// No description provided for @farmingTip_hot.
  ///
  /// In en, this message translates to:
  /// **'☀️ Too hot! Irrigation is required to protect young plants.'**
  String get farmingTip_hot;

  /// No description provided for @farmingTip_sunny.
  ///
  /// In en, this message translates to:
  /// **'☀️ Sunny day, good for harvesting and drying crops.'**
  String get farmingTip_sunny;

  /// No description provided for @farmingTip_cloudy.
  ///
  /// In en, this message translates to:
  /// **'🌥 Cloudy skies – good day for sowing seeds, soil moisture will remain.'**
  String get farmingTip_cloudy;

  /// No description provided for @farmingTip_humidity.
  ///
  /// In en, this message translates to:
  /// **'💧 High humidity – watch out for fungal diseases in crops.'**
  String get farmingTip_humidity;

  /// No description provided for @farmingTip_normal.
  ///
  /// In en, this message translates to:
  /// **'🌱 Normal conditions – good for regular farming activities.'**
  String get farmingTip_normal;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to log out, please try again.'**
  String get logoutFailed;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}'**
  String hello(Object userName);

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @botNameTitle.
  ///
  /// In en, this message translates to:
  /// **'KRISHI MITRA'**
  String get botNameTitle;

  /// No description provided for @botSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI Farming Assistant'**
  String get botSubtitle;

  /// No description provided for @krishiMitraWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m Krishi Mitra 🌱\n\nYou can ask me about crops, soil, pests, and farming. You can also send photos for analysis!'**
  String get krishiMitraWelcome;

  /// No description provided for @clearChatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChatTooltip;

  /// No description provided for @botThinking.
  ///
  /// In en, this message translates to:
  /// **'Krishi Mitra is thinking...'**
  String get botThinking;

  /// No description provided for @askBotHint.
  ///
  /// In en, this message translates to:
  /// **'Ask Krishi Mitra...'**
  String get askBotHint;

  /// No description provided for @sentImagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'📷 Sent an image for analysis'**
  String get sentImagePlaceholder;

  /// No description provided for @analyzeImagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Analyze this crop/soil image and give practical farming advice.'**
  String get analyzeImagePrompt;

  /// No description provided for @geminiApiKeyNotFound.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Gemini API Key not found. Please configure your .env file.'**
  String get geminiApiKeyNotFound;

  /// No description provided for @noResponseFromGemini.
  ///
  /// In en, this message translates to:
  /// **'⚠️ No response from Gemini.'**
  String get noResponseFromGemini;

  /// No description provided for @geminiApiError.
  ///
  /// In en, this message translates to:
  /// **'❌ Gemini API error: '**
  String get geminiApiError;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Let\'s grow together.'**
  String get welcomeBack;

  /// No description provided for @todaysWeather.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Weather'**
  String get todaysWeather;

  /// No description provided for @marketAlert.
  ///
  /// In en, this message translates to:
  /// **'Market Alert'**
  String get marketAlert;

  /// No description provided for @farmToolsAndServices.
  ///
  /// In en, this message translates to:
  /// **'Farm Tools & Services'**
  String get farmToolsAndServices;

  /// No description provided for @krishiMitra.
  ///
  /// In en, this message translates to:
  /// **'KRISHI MITRA'**
  String get krishiMitra;

  /// No description provided for @askKrishiMitra.
  ///
  /// In en, this message translates to:
  /// **'Ask KRISHI MITRA'**
  String get askKrishiMitra;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @unableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load'**
  String get unableToLoad;

  /// No description provided for @weatherData.
  ///
  /// In en, this message translates to:
  /// **'Weather data'**
  String get weatherData;

  /// No description provided for @farmToolsServices.
  ///
  /// In en, this message translates to:
  /// **'Farm Tools & Services'**
  String get farmToolsServices;

  /// No description provided for @noticeBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice Board'**
  String get noticeBoardTitle;

  /// No description provided for @latestUpdates.
  ///
  /// In en, this message translates to:
  /// **'Latest updates & announcements'**
  String get latestUpdates;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @categoryScheme.
  ///
  /// In en, this message translates to:
  /// **'Scheme'**
  String get categoryScheme;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @categoryJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get categoryJobs;

  /// No description provided for @categoryMSP.
  ///
  /// In en, this message translates to:
  /// **'MSP'**
  String get categoryMSP;

  /// No description provided for @categoryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get categoryFinance;

  /// No description provided for @labelNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get labelNew;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @noticeDetails.
  ///
  /// In en, this message translates to:
  /// **'Notice Details'**
  String get noticeDetails;

  /// No description provided for @noticeDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a detailed description of the notice. More information about the government initiative, scheme updates, or announcements will be displayed here. Farmers can find all relevant details and guidelines in this section.'**
  String get noticeDetailsDescription;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @notice1Text.
  ///
  /// In en, this message translates to:
  /// **'Cabinet has approved the Prime Minister Dhan-Dhanya agricultural scheme.'**
  String get notice1Text;

  /// No description provided for @notice2Text.
  ///
  /// In en, this message translates to:
  /// **'Expression of interest for village-level crop yield estimation using technology for selected crops 2025-26.'**
  String get notice2Text;

  /// No description provided for @notice3Text.
  ///
  /// In en, this message translates to:
  /// **'Thirteen vacancies to be filled for positions in National Farmer Welfare Implementation Society (NFWPIS).'**
  String get notice3Text;

  /// No description provided for @notice4Text.
  ///
  /// In en, this message translates to:
  /// **'Minimum Support Price (MSP) for Kharif crops for the KMS 2025-26.'**
  String get notice4Text;

  /// No description provided for @notice5Text.
  ///
  /// In en, this message translates to:
  /// **'Cabinet approved revised interest rate for FY 2025-26 with existing 1.5% interest subsidy (ISS).'**
  String get notice5Text;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadFailed;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// No description provided for @krishiMitraSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are Krishi Mitra 🌱, a multilingual AI farming assistant. Farmers may upload crop/soil/pest images. Analyze and give advice in Hindi, Punjabi, Odia, or English. Be helpful, practical, and encouraging.'**
  String get krishiMitraSystemPrompt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ml', 'or'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ml':
      return AppLocalizationsMl();
    case 'or':
      return AppLocalizationsOr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
