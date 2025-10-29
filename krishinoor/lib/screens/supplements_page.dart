import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class SupplementsPage extends StatefulWidget {
  const SupplementsPage({super.key});
  @override
  State<SupplementsPage> createState() => _SupplementsPageState();
}
class _SupplementsPageState extends State<SupplementsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Map<String, String>> products = const [
    {
      "name": "Organic Fertilizer",
      "description": "Premium quality organic fertilizer for healthy crops",
      "image": "assets/images/fertilizer.jpg",
      "url":
          "https://www.amazon.in/Ugaoo-Organic-Vermicompost-Fertilizer-Plants/dp/B0BDVN579S/ref=sr_1_2_sspa?crid=2KP7WKW1IO9MP&dib=eyJ2IjoiMSJ9.QV-0XUcfS9ZGzOzKpmUrYswgL34rCzTOyBHTi1HuiTLb22VRnNRS5e5_dLb9KaWS5p6t9sCPTe6a4QUm-x30NQTKD0iu67lvwy9BbcjV8xb6tgFoE2R2iP_TBGTnt4e1G9l2kYTLVTZjkVI_FNQCSjpA1OaxT5voq8VOweDDX8eHKnEG6acvgeJmTl81_8Wv4YBTNOJAL8LKFyz8EGXiEGk7bVa3K2NWP4KuQlVto9ICrzQG8pw7xFneR4eou2gYAH_9bM2uv53LN1x0OQBtOrQrzfmzjksM6fiol6fQVy4.88gJoowfAwWO5Q943lH4V3Q07YbZF2Nxjd2UzEawDOw&dib_tag=se&keywords=ORGANIC%2BFERTILIZER&qid=1757942906&sprefix=organic%2Bfertilizer%2Caps%2C300&sr=8-2-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1"
    },
    {
      "name": "Pesticide Spray",
      "description": "Effective and safe pest control solution",
      "image": "assets/images/spray.jpg",
      "url":
          "https://www.amazon.in/Chipku-Pressed-Soluble-Plants-Garden/dp/B08VRJLGL9/ref=sr_1_1_sspa?crid=23LYX3O34VU4H&dib=eyJ2IjoiMSJ9.kqOUmuQc5IYB0C1w14PHN3qqctHnehwdqK70aOugIAZ09QxyLWDVou-_7bewhiZWRGQI3uKWNbmoXa3XHZ_G090YIiTVVatYfYD2Sv9vohO5N2P7UIyBl6EWiHSeVnRuPYk8ofA3nShIIQ5yCm_eRLQY_w2I-qKujfDpJAyk8y0TfEQRcxDDer36pQEV-Px9nnt9jmIAHX3QAO5UqLVBfFCCx-zxJU5jCacDQFPT0oAA6rX0DvK755OCxcnQa54l9TWcotTHBXclyVwwRpJ7a2oiJolHx89HHXNwGx4JesE.C0bSW95bOlDGMhpnQMj2C6ih4n5JIjV_0Oj7C2Vhn28&dib_tag=se&keywords=Pesticide%2BSpray&qid=1757943212&sprefix=pesticide%2Bspray%2Caps%2C300&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1"
    },
    {
      "name": "Soil Nutrients",
      "description": "Complete nutrient solution for all crops",
      "image": "assets/images/nutrients.jpg",
      "url":
          "https://www.amazon.in/IFFCO-Urban-Gardens-Purpose-Organic/dp/B085M784T3/ref=sr_1_1_sspa?crid=1JLVS9OSKSHE5&dib=eyJ2IjoiMSJ9.QV-0XUcfS9ZGzOzKpmUrYi7M6h4Iaa1W8UMhxtefRpSXPFZFOkhe5BPl81zBAvNiK65NGALH3I5taWuCt4QgEjfKXygqCIZJPvflf9EYiwH6cu6MSOvvK-l5-HnUSPWQdacQnGEw-eX7pwWUoi70Xf8lhFShN2P_UwK0hPXW8pbnhtXlRdlpA1NUWjguxKrWu_btJcGp-2q0TKyNPsZJUwRccOuOckwDuXGn8nKHiQn9L4M6LTdfy2tYL7RBJ0HlwDrI1nH2AEP9lUFJAQSUQEHVQ2Rx0l4InrCR0HzgtnM.syRWP50bWfbenGKEvGTwgcv8T_vkcC6lR1QecXFRTf8&dib_tag=se&keywords=Soil%2BNutrients&qid=1757943594&sprefix=soil%2Bnutrients%2Caps%2C346&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1"
    },
  ];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text("Could not open link")),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
  Widget _buildProductCard(Map<String, String> product, int index) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.5 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.asset(
                        product["image"]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(76),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["name"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product["description"]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _launchURL(product["url"]!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.shopping_cart, size: 18),
                              SizedBox(width: 8),
                              Text(
                                "Buy Now",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              Colors.white,
              Colors.green.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
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
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: Colors.green.shade700),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.green.shade700,
                                    Colors.teal.shade600
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  "Farm Supplements",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Quality products at low costs",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(products[index], index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}