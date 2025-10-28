import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';

class MarketPricePage extends StatefulWidget {
  const MarketPricePage({super.key});

  @override
  State<MarketPricePage> createState() => _MarketPricePageState();
}

class _MarketPricePageState extends State<MarketPricePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  final List<Map<String, dynamic>> products = const [
    {
      "name": "Urea (50 kg)",
      "icon": Icons.grass,
      "amazon": 600,
      "flipkart": 620,
      "mandi": 590,
      "trend": [580, 590, 595, 600, 590],
      "type": "Fertilizers",
    },
    {
      "name": "DAP (50 kg)",
      "icon": Icons.local_florist,
      "amazon": 1200,
      "flipkart": 1180,
      "mandi": 1150,
      "trend": [1100, 1120, 1150, 1170, 1150],
      "type": "Fertilizers",
    },
    {
      "name": "Wheat Seeds (1 kg)",
      "icon": Icons.grain,
      "amazon": 50,
      "flipkart": 55,
      "mandi": 45,
      "trend": [40, 42, 45, 47, 45],
      "type": "Seeds",
    },
    {
      "name": "Pesticide Spray 1L",
      "icon": Icons.sanitizer,
      "amazon": 250,
      "flipkart": 240,
      "mandi": 230,
      "trend": [220, 225, 230, 235, 230],
      "type": "Sprays",
    },
    {
      "name": "Zinc Nutrient (1 kg)",
      "icon": Icons.science,
      "amazon": 150,
      "flipkart": 155,
      "mandi": 140,
      "trend": [135, 140, 145, 150, 140],
      "type": "Nutrients",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            // Header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF66BB6A),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Back button and title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.store, color: Colors.white, size: 24),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.marketTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Compare prices & save more',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(230),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tab bar
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      height: 50,
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: Color(0xFF4CAF50),
                        unselectedLabelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(text: l10n.tabFertilizers),
                          Tab(text: l10n.tabSeeds),
                          Tab(text: l10n.tabSprays),
                          Tab(text: l10n.tabNutrients),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: TabBarView(
                  children: [
                    _buildDashboard(context, "Fertilizers"),
                    _buildDashboard(context, "Seeds"),
                    _buildDashboard(context, "Sprays"),
                    _buildDashboard(context, "Nutrients"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, String type) {
    final filteredProducts =
        products.where((product) => product['type'] == type).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (filteredProducts.isNotEmpty) ...[
          _buildTrendChart(context, filteredProducts),
          const SizedBox(height: 16),
        ],
        ...filteredProducts.asMap().entries.map((entry) {
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 300 + (entry.key * 100)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildProductCard(context, entry.value),
                ),
              );
            },
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final l10n = AppLocalizations.of(context)!;
    final best = _getBestOption(product);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    product['icon'],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.trending_up, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            'Market Active',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: best == "Mandi"
                          ? [Color(0xFF4CAF50), Color(0xFF66BB6A)]
                          : best == "Amazon"
                              ? [Color(0xFFFF9800), Color(0xFFFFA726)]
                              : [Color(0xFF2196F3), Color(0xFF42A5F5)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        _getLocalizedBest(l10n, best),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _priceTile(l10n.amazon, product['amazon'], best == "Amazon", Colors.orange),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _priceTile(l10n.flipkart, product['flipkart'], best == "Flipkart", Colors.blue),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _priceTile(l10n.mandi, product['mandi'], best == "Mandi", Color(0xFF4CAF50)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceTile(String label, int price, bool highlight, Color accentColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: highlight
              ? BoxDecoration(
                  color: accentColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accentColor.withAlpha(102)),
                )
              : null,
          child: Text(
            "₹$price",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlight ? accentColor : Colors.black87,
              fontSize: highlight ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendChart(BuildContext context, List<Map<String, dynamic>> filteredProducts) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.show_chart, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Price Trends',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${value.toInt()}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.day(value.toInt() + 1),
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: filteredProducts.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final product = entry.value;
                  return LineChartBarData(
                    spots: _mapTrend(product['trend']),
                    isCurved: true,
                    curveSmoothness: 0.4,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: _getColorForIndex(idx),
                        );
                      },
                    ),
                    gradient: LinearGradient(
                      colors: [
                        _getColorForIndex(idx).withAlpha(204),
                        _getColorForIndex(idx),
                      ],
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _getColorForIndex(idx).withAlpha(51),
                          _getColorForIndex(idx).withAlpha(13),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
      Color(0xFFFF9800),
      Color(0xFF9C27B0),
      Color(0xFFE91E63),
    ];
    return colors[index % colors.length];
  }

  List<FlSpot> _mapTrend(List<int> trend) {
    return List.generate(trend.length, (i) => FlSpot(i.toDouble(), trend[i].toDouble()));
  }

  String _getBestOption(Map<String, dynamic> product) {
    int amazon = product['amazon'];
    int flipkart = product['flipkart'];
    int mandi = product['mandi'];

    int minPrice = [amazon, flipkart, mandi].reduce((a, b) => a < b ? a : b);

    if (minPrice == mandi) return "Mandi";
    if (minPrice == amazon) return "Amazon";
    return "Flipkart";
  }

  String _getLocalizedBest(AppLocalizations l10n, String best) {
    switch (best) {
      case "Amazon":
        return l10n.amazon;
      case "Flipkart":
        return l10n.flipkart;
      case "Mandi":
        return l10n.mandi;
      default:
        return best;
    }
  }
}