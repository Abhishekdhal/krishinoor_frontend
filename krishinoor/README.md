# Krishinoor 🌾

**Krishinoor** (कृषिनूर) is a comprehensive, AI-powered agricultural helper app designed to support Indian farmers with real-time analytics, dynamic crop recommendations, smart diagnostics, and regional market updates. 

Powered by **Gemini 2.5 Flash**, Krishinoor bridges the gap between modern agricultural science and local farming practices, delivering actionable advice in regional Indian languages.

---

## 🚀 Key Features

*   **🌱 Soil Health Analyzer:** Input soil measurements (pH, Nitrogen, Phosphorus, Potassium) to receive an AI-powered evaluation of your soil type, along with custom crop suitability recommendations.
*   **🤖 Krishi Mitra (AI Bot):** Your 24/7 personal farming assistant. Ask questions about crop cycles, pest management, or upload images of your crops for real-time analysis.
*   **⛅ Smart Weather Companion:** Access live weather updates coupled with daily farming tips based on atmospheric conditions (e.g., advice on watering, harvesting, or spraying).
*   **🛒 Farm Supplements:** Browse curated, low-cost organic fertilizers, pest controls, and nutrients with direct buying options.
*   **📸 Crop Problem Detector:** Upload images of infected or diseased crops along with description reports to identify issues quickly.
*   **📢 Notice Board & Schemes:** Real-time updates on agricultural schemes (like PM Dhan-Dhanya), Minimum Support Price (MSP), and announcements.
*   **🌐 Multilingual Support:** Ready for diverse Indian regions with complete localizations in **Hindi (हिन्दी)**, **Odia (ଓଡ଼ିଆ)**, **Malayalam (മലയാളം)**, and **English**.

---

## 🛠️ Tech Stack

*   **Frontend Framework:** Flutter (Dart)
*   **AI Integration:** Google Generative AI (Gemini API)
*   **State Management & UI Utilities:** Flutter Material Design 3, TickerProvider animations, fl_chart
*   **Local Storage & Session Cache:** Flutter Secure Storage, SharedPreferences, Hive (DbProvider)
*   **Localization:** Flutter l10n (intl)
*   **Third-party Services:** Geolocator (location mapping), Speech-to-Text (voice commands)

---

## ⚙️ Project Setup

### Prerequisites

*   Flutter SDK (v3.19.0 or higher recommended)
*   Dart SDK
*   A Gemini API Key (get one from [Google AI Studio](https://aistudio.google.com/))

### Installation Steps

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Abhishekdhal/krishinoor_frontend.git
    cd krishinoor_frontend/krishinoor
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Environment Variables:**
    Create a `.env` file in the root folder (`krishinoor/`) and configure your API keys:
    ```env
    GEMINI_API_KEY=your_gemini_api_key_here
    API_BASE_URL=https://your-backend-api-url.com
    ```

4.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 📂 Architecture & Directory Structure

```text
lib/
├── l10n/                 # Localization files (.arb & generated code)
├── screens/              # App screen layouts
│   ├── soil_health_page.dart
│   ├── ai_bot_page.dart
│   ├── supplements_page.dart
│   ├── feedback_page.dart
│   └── ...
├── services/             # API connection and data storage services
└── main.dart             # Application entry point
```

---

## 🤝 Contributing

We welcome contributions to make farming smarter and easier! Feel free to raise issues, submit pull requests, or request features.
