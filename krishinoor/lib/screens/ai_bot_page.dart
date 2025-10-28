import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../l10n/app_localizations.dart'; // Import L10n
import 'package:flutter/foundation.dart'; // Import kDebugMode

class AIBotPage extends StatefulWidget {
  const AIBotPage({super.key});

  @override
  State<AIBotPage> createState() => _AIBotPageState();
}

class _AIBotPageState extends State<AIBotPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  bool _isListening = false;
  bool _isLoading = false;
  File? _selectedImage;
  
  // FIX: Make apiKey and _model late
  late final String apiKey; 
  late GenerativeModel _model;

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Theme colors matching your app
  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color lightGreen = const Color(0xFF66BB6A);
  final Color accentGold = const Color(0xFFFFB300);
  final Color backgroundWhite = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    
    // FIX: Initialize apiKey and _model safely inside initState
    try {
      // Dart's non-nullable access is safe here since dotenv is loaded in main.dart
      apiKey = dotenv.env['GEMINI_API_KEY']!;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("FATAL ERROR: Failed to read GEMINI_API_KEY. Ensure it is set in .env.");
      }
      apiKey = "";
    }
    
    if (apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: "gemini-2.5-flash",
        apiKey: apiKey,
      );
    }

    _setupAnimations();
    
    // Call in post-frame callback to ensure context is available for l10n
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  // Uses the localized welcome string
  void _addWelcomeMessage() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      messages.add({"role": "bot", "text": l10n.krishiMitraWelcome});
    });
  }

  // NOTE: Reverting error messages to hardcoded strings as localized keys were not provided.
  Future<String> _getAIResponse(
    String userMessage,
    AppLocalizations l10n, {
    String? base64Image,
  }) async {
    if (apiKey.isEmpty) {
      return "⚠️ Gemini API Key not found. Please configure your .env file.";
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prompt = Content.multi([
        // Setting the model's role
        TextPart(l10n.krishiMitraSystemPrompt),
        TextPart(userMessage),
        if (base64Image != null)
          DataPart("image/jpeg", base64Decode(base64Image)),
      ]);

      final response = await _model.generateContent([prompt]);
      return response.text ?? "⚠️ No response from Gemini.";
    } catch (e) {
      return "❌ Gemini API error: $e";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendMessage({bool isImage = false}) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!; // Get L10n object

    if (!isImage && _controller.text.trim().isEmpty) return;
    
    // Check if model is initialized before proceeding
    if (apiKey.isEmpty) {
      setState(() {
        messages.add({"role": "bot", "text": "⚠️ Cannot send message. Gemini model failed to initialize due to missing API Key."});
      });
      _scrollToBottom();
      return;
    }


    final userText = _controller.text.trim();
    String? base64Image;

    if (isImage && _selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    setState(() {
      messages.add({
        "role": "user",
        // Use localized placeholder for image message
        "text": userText.isEmpty ? l10n.sentImagePlaceholder : userText
      });
    });

    _controller.clear();
    _scrollToBottom();

    final botReply = await _getAIResponse(
      // Use localized prompt for image analysis if text is empty
      userText.isEmpty ? l10n.analyzeImagePrompt : userText,
      l10n,
      base64Image: base64Image,
    );

    setState(() {
      messages.add({"role": "bot", "text": botReply});
    });

    _scrollToBottom();
    _selectedImage = null;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _listenVoice() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == "done") setState(() => _isListening = false);
        },
        onError: (error) {
          setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _sendMessage(isImage: true);
    }
  }

  void _clearChat() {
    setState(() {
      messages.clear();
    });
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get L10n object once in build method
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundWhite,
              lightGreen.withAlpha(26),
              primaryGreen.withAlpha(13),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildCustomAppBar(l10n),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildChatArea(l10n),
                ),
              ),
            ),
            _buildInputArea(l10n),
          ],
        ),
      ),
    );
  }

  // --- Custom App Bar ---

  Widget _buildCustomAppBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
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
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withAlpha(76),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accentGold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.botNameTitle.toUpperCase(), // Localized App Bar Title
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  l10n.botSubtitle, // Localized App Bar Subtitle
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: _clearChat,
            tooltip: l10n.clearChatTooltip, // Localized Tooltip
          ),
        ],
      ),
    );
  }

  // --- Chat Area and Logic ---

  Widget _buildChatArea(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutBack,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: _buildMessageBubble(msg["text"] ?? "", isUser),
                );
              },
            ),
          ),
          if (_isLoading) _buildTypingIndicator(l10n),
          if (_selectedImage != null) _buildImagePreview(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [lightGreen, primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 8),
            bottomRight: Radius.circular(isUser ? 8 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightGreen, primaryGreen],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightGreen, primaryGreen],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.botThinking, // Localized typing indicator
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(width: 8),
              const _TypingDots(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(_selectedImage!, height: 120, fit: BoxFit.cover),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () => setState(() => _selectedImage = null),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Input Controls ---

  Widget _buildInputArea(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildActionButton(
              icon: _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : primaryGreen,
              onPressed: _listenVoice,
              isActive: _isListening,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.camera_alt,
              color: primaryGreen,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.image,
              color: primaryGreen,
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundWhite,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: primaryGreen.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.askBotHint, // Localized hint text
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.1),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [lightGreen, primaryGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withAlpha(102),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? color.withAlpha(51) : Colors.grey.shade100,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? color : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 18),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// --- Typing Dots Widget ---

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            double delay = i * 0.3;
            double animValue = (_controller.value - delay) % 1.0;
            double opacity =
                animValue < 0.5 ? (animValue * 2) : (2 - animValue * 2);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
