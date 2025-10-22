// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KRISHINOOR';

  @override
  String get welcome => 'Welcome';

  @override
  String get authMessage => 'Securely login to your account';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get password => 'Password';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get or => 'OR';

  @override
  String get continueButton => 'Continue';

  @override
  String get email => 'Email';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get language => 'Preferred Language';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get signupSuccess => 'Sign up successful!';

  @override
  String get signupFailed => 'Sign up failed';

  @override
  String get logout => 'Logout';

  @override
  String get homeTitle => 'Farmers of India';

  @override
  String get supplements => 'Supplements';

  @override
  String get weather => 'Weather';

  @override
  String get aiBot => 'AI Bot';

  @override
  String get noticeBoard => 'Notice Board';

  @override
  String get iotFarming => 'IoT Farming';

  @override
  String get soilHealth => 'Soil Health';

  @override
  String get marketPrices => 'Market Prices';

  @override
  String get cropProblemDetector => 'Crop Problem Detector';

  @override
  String get feedback => 'Feedback';

  @override
  String get askAIBot => 'Ask AI Bot';

  @override
  String get soilHealthTitle => 'Soil Fertility Analyzer';

  @override
  String get enterValues => '🌱 Enter Soil Test Values';

  @override
  String get phLabel => 'Soil pH (e.g., 6.5)';

  @override
  String get nLabel => 'Nitrogen (0-100)';

  @override
  String get pLabel => 'Phosphorus (0-100)';

  @override
  String get kLabel => 'Potassium (0-100)';

  @override
  String get analyzeButton => 'Analyze Soil';

  @override
  String get bestPractices => '✅ Best Practices';

  @override
  String get practice1 => 'Use organic manure to improve soil structure.';

  @override
  String get practice2 => 'Rotate crops to maintain fertility.';

  @override
  String get practice3 => 'Avoid excessive use of chemical fertilizers.';

  @override
  String get practice4 => 'Test soil every 2-3 years for better planning.';

  @override
  String get invalidValues => 'Please enter valid numeric values.';

  @override
  String get acidicSoil =>
      'Soil is acidic.\nAdd lime.\nCrops: Potato, Pineapple, Rice.';

  @override
  String get alkalineSoil =>
      'Soil is alkaline.\nAdd gypsum/organic matter.\nCrops: Cotton, Sugar beet, Barley.';

  @override
  String get goodSoil => 'Soil pH is good for most crops.';

  @override
  String get addN => 'Add Urea (Nitrogen).';

  @override
  String get addP => 'Add DAP (Phosphorus).';

  @override
  String get addK => 'Add MOP (Potassium).';

  @override
  String get balancedNPK => 'NPK levels are balanced. Maintain with compost.';

  @override
  String get marketTitle => '🌾 Market Prices';

  @override
  String get tabFertilizers => 'Fertilizers';

  @override
  String get tabSeeds => 'Seeds';

  @override
  String get tabSprays => 'Sprays';

  @override
  String get tabNutrients => 'Nutrients';

  @override
  String get bestLabel => 'Best';

  @override
  String get amazon => 'Amazon';

  @override
  String get flipkart => 'Flipkart';

  @override
  String get mandi => 'Mandi';

  @override
  String day(Object value) {
    return 'Day $value';
  }

  @override
  String get iotTitle => 'IoT-based Farming';

  @override
  String get iotDescription => 'Soil suitability analysis using IoT devices.';

  @override
  String get feedbackTitle => '💬 Feedback';

  @override
  String get feedbackHeader => 'We value your feedback 💚';

  @override
  String get yourName => 'Your Name';

  @override
  String get yourFeedback => 'Your Feedback';

  @override
  String get noImage => '📷 No image selected';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get thankYou => '🎉 Thank You!';

  @override
  String get thankYouMessage =>
      'Your feedback has been submitted successfully.\nWe appreciate your time 💚';

  @override
  String get ok => 'OK';

  @override
  String get pleaseEnter => '⚠️ Please enter name and feedback';

  @override
  String get problemDetectorTitle => 'Problem Detector';

  @override
  String get problemDescription => 'Problem Description';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get takeChooseImage => 'Take/Choose Image';

  @override
  String get upload => 'UPLOAD';

  @override
  String get addDescriptionAndImage => 'Please add description and image ❌';

  @override
  String get problemReportedSuccess => 'Problem reported successfully ✅';

  @override
  String get error => 'Error ❌ ';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get farmingTip_rain =>
      '🌧 Good for paddy and rice crops. Avoid pesticide spraying today.';

  @override
  String get farmingTip_hot =>
      '☀️ Too hot! Irrigation is required to protect young plants.';

  @override
  String get farmingTip_sunny =>
      '☀️ Sunny day, good for harvesting and drying crops.';

  @override
  String get farmingTip_cloudy =>
      '🌥 Cloudy skies – good day for sowing seeds, soil moisture will remain.';

  @override
  String get farmingTip_humidity =>
      '💧 High humidity – watch out for fungal diseases in crops.';

  @override
  String get farmingTip_normal =>
      '🌱 Normal conditions – good for regular farming activities.';

  @override
  String get farmer => 'Farmer';

  @override
  String get notAvailable => 'N/A';

  @override
  String get logoutFailed => 'Failed to log out, please try again.';

  @override
  String hello(Object userName) {
    return 'Hello, $userName';
  }

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get profile => 'Profile';

  @override
  String get save => 'Save';

  @override
  String get botNameTitle => 'KRISHI MITRA';

  @override
  String get botSubtitle => 'Your AI Farming Assistant';

  @override
  String get krishiMitraWelcome =>
      'Hello! I\'m Krishi Mitra 🌱\n\nYou can ask me about crops, soil, pests, and farming. You can also send photos for analysis!';

  @override
  String get clearChatTooltip => 'Clear Chat';

  @override
  String get botThinking => 'Krishi Mitra is thinking...';

  @override
  String get askBotHint => 'Ask Krishi Mitra...';

  @override
  String get sentImagePlaceholder => '📷 Sent an image for analysis';

  @override
  String get analyzeImagePrompt =>
      'Analyze this crop/soil image and give practical farming advice.';

  @override
  String get geminiApiKeyNotFound =>
      '⚠️ Gemini API Key not found. Please configure your .env file.';

  @override
  String get noResponseFromGemini => '⚠️ No response from Gemini.';

  @override
  String get geminiApiError => '❌ Gemini API error: ';

  @override
  String get welcomeBack => 'Welcome back! Let\'s grow together.';

  @override
  String get todaysWeather => 'Today\'s Weather';

  @override
  String get marketAlert => 'Market Alert';

  @override
  String get farmToolsAndServices => 'Farm Tools & Services';

  @override
  String get krishiMitra => 'KRISHI MITRA';

  @override
  String get askKrishiMitra => 'Ask KRISHI MITRA';

  @override
  String get loading => 'Loading...';

  @override
  String get unableToLoad => 'Unable to load';

  @override
  String get weatherData => 'Weather data';

  @override
  String get farmToolsServices => 'Farm Tools & Services';

  @override
  String get noticeBoardTitle => 'Notice Board';

  @override
  String get latestUpdates => 'Latest updates & announcements';

  @override
  String get filterAll => 'All';

  @override
  String get categoryScheme => 'Scheme';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get categoryJobs => 'Jobs';

  @override
  String get categoryMSP => 'MSP';

  @override
  String get categoryFinance => 'Finance';

  @override
  String get labelNew => 'NEW';

  @override
  String get readMore => 'Read More';

  @override
  String get noticeDetails => 'Notice Details';

  @override
  String get noticeDetailsDescription =>
      'This is a detailed description of the notice. More information about the government initiative, scheme updates, or announcements will be displayed here. Farmers can find all relevant details and guidelines in this section.';

  @override
  String get learnMore => 'Learn More';

  @override
  String get notice1Text =>
      'Cabinet has approved the Prime Minister Dhan-Dhanya agricultural scheme.';

  @override
  String get notice2Text =>
      'Expression of interest for village-level crop yield estimation using technology for selected crops 2025-26.';

  @override
  String get notice3Text =>
      'Thirteen vacancies to be filled for positions in National Farmer Welfare Implementation Society (NFWPIS).';

  @override
  String get notice4Text =>
      'Minimum Support Price (MSP) for Kharif crops for the KMS 2025-26.';

  @override
  String get notice5Text =>
      'Cabinet approved revised interest rate for FY 2025-26 with existing 1.5% interest subsidy (ISS).';
}
