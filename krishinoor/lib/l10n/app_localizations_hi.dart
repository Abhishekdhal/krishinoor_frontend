// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'कृषिनूर';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get authMessage => 'अपने खाते में सुरक्षित रूप से लॉगिन करें';

  @override
  String get login => 'लॉगिन करें';

  @override
  String get signup => 'साइन अप करें';

  @override
  String get loginWithGoogle => 'गूगल के साथ जारी रखें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get dontHaveAccount => 'खाता नहीं है?';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get or => 'या';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get email => 'ईमेल';

  @override
  String get name => 'नाम';

  @override
  String get phone => 'फ़ोन नंबर';

  @override
  String get language => 'पसंदीदा भाषा';

  @override
  String get fillAllFields => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get invalidCredentials => 'अमान्य क्रेडेंशियल्स';

  @override
  String get loginFailed => 'लॉगिन विफल';

  @override
  String get signupSuccess => 'साइन अप सफल!';

  @override
  String get signupFailed => 'साइन अप विफल';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get homeTitle => 'भारत के किसान';

  @override
  String get supplements => 'पूरक';

  @override
  String get weather => 'मौसम';

  @override
  String get aiBot => 'एआई बोट';

  @override
  String get noticeBoard => 'सूचना पटल';

  @override
  String get iotFarming => 'आईओटी खेती';

  @override
  String get soilHealth => 'मिट्टी का स्वास्थ्य';

  @override
  String get marketPrices => 'बाज़ार मूल्य';

  @override
  String get cropProblemDetector => 'फसल समस्या डिटेक्टर';

  @override
  String get feedback => 'फीडबैक';

  @override
  String get askAIBot => 'एआई बोट से पूछें';

  @override
  String get soilHealthTitle => 'मिट्टी उर्वरता विश्लेषक';

  @override
  String get enterValues => '🌱 मिट्टी परीक्षण मान दर्ज करें';

  @override
  String get phLabel => 'मिट्टी का पीएच (जैसे, 6.5)';

  @override
  String get nLabel => 'नाइट्रोजन (0-100)';

  @override
  String get pLabel => 'फास्फोरस (0-100)';

  @override
  String get kLabel => 'पोटेशियम (0-100)';

  @override
  String get analyzeButton => 'मिट्टी का विश्लेषण करें';

  @override
  String get bestPractices => '✅ सर्वोत्तम अभ्यास';

  @override
  String get practice1 =>
      'मिट्टी की संरचना सुधारने के लिए जैविक खाद का प्रयोग करें।';

  @override
  String get practice2 => 'उर्वरता बनाए रखने के लिए फसलों को बदल-बदल कर बोएं।';

  @override
  String get practice3 => 'रासायनिक उर्वरकों का अत्यधिक उपयोग करने से बचें।';

  @override
  String get practice4 =>
      'बेहतर योजना के लिए हर 2-3 साल में मिट्टी का परीक्षण करें।';

  @override
  String get invalidValues => 'कृपया वैध संख्यात्मक मान दर्ज करें।';

  @override
  String get acidicSoil =>
      'मिट्टी अम्लीय है।\nचूना डालें।\nफसलें: आलू, अनानास, चावल।';

  @override
  String get alkalineSoil =>
      'मिट्टी क्षारीय है।\nजिप्सम/जैविक पदार्थ डालें।\nफसलें: कपास, चुकंदर, जौ।';

  @override
  String get goodSoil => 'मिट्टी का पीएच अधिकांश फसलों के लिए अच्छा है।';

  @override
  String get addN => 'यूरिया (नाइट्रोजन) डालें।';

  @override
  String get addP => 'डीएपी (फास्फोरस) डालें।';

  @override
  String get addK => 'एमओपी (पोटेशियम) डालें।';

  @override
  String get balancedNPK => 'एनपीके का स्तर संतुलित है। खाद से बनाए रखें।';

  @override
  String get marketTitle => '🌾 बाज़ार मूल्य';

  @override
  String get tabFertilizers => 'उर्वरक';

  @override
  String get tabSeeds => 'बीज';

  @override
  String get tabSprays => 'स्प्रे';

  @override
  String get tabNutrients => 'पोषक तत्व';

  @override
  String get bestLabel => 'सर्वोत्तम';

  @override
  String get amazon => 'अमेज़न';

  @override
  String get flipkart => 'फ्लिपकार्ट';

  @override
  String get mandi => 'मंडी';

  @override
  String day(Object value) {
    return 'दिन $value';
  }

  @override
  String get iotTitle => 'आईओटी-आधारित खेती';

  @override
  String get iotDescription =>
      'आईओटी उपकरणों का उपयोग करके मिट्टी की उपयुक्तता का विश्लेषण।';

  @override
  String get feedbackTitle => '💬 फीडबैक';

  @override
  String get feedbackHeader => 'हम आपके फीडबैक को महत्व देते हैं 💚';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get yourFeedback => 'आपका फीडबैक';

  @override
  String get noImage => '📷 कोई छवि नहीं चुनी गई';

  @override
  String get uploadPhoto => 'फोटो अपलोड करें';

  @override
  String get submitFeedback => 'फीडबैक सबमिट करें';

  @override
  String get thankYou => '🎉 धन्यवाद!';

  @override
  String get thankYouMessage =>
      'आपका फीडबैक सफलतापूर्वक सबमिट कर दिया गया है।\nहम आपके समय की सराहना करते हैं 💚';

  @override
  String get ok => 'ठीक है';

  @override
  String get pleaseEnter => '⚠️ कृपया नाम और फीडबैक दर्ज करें';

  @override
  String get problemDetectorTitle => 'समस्या डिटेक्टर';

  @override
  String get problemDescription => 'समस्या का विवरण';

  @override
  String get noImageSelected => 'कोई छवि नहीं चुनी गई';

  @override
  String get takeChooseImage => 'छवि लें/चुनें';

  @override
  String get upload => 'अपलोड करें';

  @override
  String get addDescriptionAndImage => 'कृपया विवरण और छवि जोड़ें ❌';

  @override
  String get problemReportedSuccess => 'समस्या सफलतापूर्वक रिपोर्ट की गई ✅';

  @override
  String get error => 'त्रुटि ❌ ';

  @override
  String get weatherTitle => 'मौसम';

  @override
  String get farmingTip_rain =>
      '🌧 धान और चावल की फसलों के लिए अच्छा है। आज कीटनाशक छिड़काव से बचें।';

  @override
  String get farmingTip_hot =>
      '☀️ बहुत गर्म! युवा पौधों को बचाने के लिए सिंचाई की आवश्यकता है।';

  @override
  String get farmingTip_sunny =>
      '☀️ धूप वाला दिन, कटाई और फसल सुखाने के लिए अच्छा है।';

  @override
  String get farmingTip_cloudy =>
      '🌥 बादल छाए हुए हैं – बीज बोने के लिए अच्छा दिन, मिट्टी की नमी बनी रहेगी।';

  @override
  String get farmingTip_humidity =>
      '💧 उच्च आर्द्रता – फसलों में फफूंद जनित रोगों से सावधान रहें।';

  @override
  String get farmingTip_normal =>
      '🌱 सामान्य स्थितियाँ – नियमित खेती की गतिविधियों के लिए अच्छा है।';

  @override
  String get farmer => 'किसान';

  @override
  String get notAvailable => 'उपलब्ध नहीं है';

  @override
  String get logoutFailed => 'लॉग आउट विफल रहा, कृपया पुनः प्रयास करें।';

  @override
  String hello(Object userName) {
    return 'नमस्ते, $userName';
  }

  @override
  String get profileUpdated => 'प्रोफाइल सफलतापूर्वक अपडेट की गई!';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get save => 'सहेजें';

  @override
  String get botNameTitle => 'कृषि मित्र';

  @override
  String get botSubtitle => 'आपका एआई कृषि सहायक';

  @override
  String get krishiMitraWelcome =>
      'नमस्ते! मैं कृषि मित्र हूँ 🌱\n\nआप मुझसे फसल, मिट्टी, कीट-पतंगों और खेती के बारे में सवाल पूछ सकते हैं। आप विश्लेषण के लिए तस्वीरें भी भेज सकते हैं!';

  @override
  String get clearChatTooltip => 'चैट साफ़ करें';

  @override
  String get botThinking => 'कृषि मित्र सोच रहा है...';

  @override
  String get askBotHint => 'कृषि मित्र से पूछें...';

  @override
  String get sentImagePlaceholder => '📷 विश्लेषण के लिए एक तस्वीर भेजी';

  @override
  String get analyzeImagePrompt =>
      'इस फसल/मिट्टी की तस्वीर का विश्लेषण करें और व्यावहारिक खेती की सलाह दें।';

  @override
  String get geminiApiKeyNotFound =>
      '⚠️ जेमिनी एपीआई कुंजी नहीं मिली। कृपया अपनी .env फ़ाइल कॉन्फ़िगर करें।';

  @override
  String get noResponseFromGemini => '⚠️ जेमिनी से कोई प्रतिक्रिया नहीं।';

  @override
  String get geminiApiError => '❌ जेमिनी एपीआई त्रुटि: ';

  @override
  String get welcomeBack =>
      'फिर से स्वागत है! आइए साथ मिलकर खेती को आगे बढ़ाएँ।';

  @override
  String get todaysWeather => 'आज का मौसम';

  @override
  String get marketAlert => 'बाज़ार अलर्ट';

  @override
  String get farmToolsAndServices => 'खेती उपकरण और सेवाएँ';

  @override
  String get krishiMitra => 'कृषि मित्र';

  @override
  String get askKrishiMitra => 'कृषि मित्र से पूछें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get unableToLoad => 'लोड करने में असमर्थ';

  @override
  String get weatherData => 'मौसम डेटा';

  @override
  String get farmToolsServices => 'कृषि उपकरण और सेवाएं';

  @override
  String get noticeBoardTitle => 'नोटिस बोर्ड';

  @override
  String get latestUpdates => 'नवीनतम अपडेट और घोषणाएँ';

  @override
  String get filterAll => 'सभी';

  @override
  String get categoryScheme => 'योजना';

  @override
  String get categoryTechnology => 'प्रौद्योगिकी';

  @override
  String get categoryJobs => 'नौकरी';

  @override
  String get categoryMSP => 'MSP';

  @override
  String get categoryFinance => 'वित्त';

  @override
  String get labelNew => 'नया';

  @override
  String get readMore => 'और पढ़ें';

  @override
  String get noticeDetails => 'नोटिस विवरण';

  @override
  String get noticeDetailsDescription =>
      'यह नोटिस का विस्तृत विवरण है। सरकारी पहल, योजना अद्यतन, या घोषणाओं के बारे में अधिक जानकारी यहाँ दिखाई जाएगी। किसान इस अनुभाग में सभी संबंधित निर्देश और विवरण पा सकते हैं।';

  @override
  String get learnMore => 'और जानें';

  @override
  String get notice1Text =>
      'कैबिनेट ने प्रधानमंत्री धन-धान्य कृषि योजना को मंज़ूरी दी।';

  @override
  String get notice2Text =>
      '2025-26 के लिए चयनित फसलों हेतु ग्राम पंचायत स्तर पर प्रौद्योगिकी का उपयोग कर फसल उपज अनुमान के लिए रुचि की अभिव्यक्ति।';

  @override
  String get notice3Text =>
      'राष्ट्रीय किसान कल्याण कार्यान्वयन सोसाइटी (NFWPIS) में नियुक्ति के लिए तेरह पदों को भरना।';

  @override
  String get notice4Text =>
      'खरीफ विपणन मौसम (KMS) 2025-26 के लिए खरीफ फसलों के न्यूनतम समर्थन मूल्य।';

  @override
  String get notice5Text =>
      'कैबिनेट ने वित्त वर्ष 2025-26 के लिए मौजूदा 1.5% ब्याज अनुदान (ISS) के साथ संशोधित ब्याज दर को मंजूरी दी।';
}
