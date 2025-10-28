import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';

class SoilHealthPage extends StatefulWidget {
  const SoilHealthPage({super.key});

  @override
  State<SoilHealthPage> createState() => _SoilHealthPageState();
}

class _SoilHealthPageState extends State<SoilHealthPage> with TickerProviderStateMixin {
  final TextEditingController phController = TextEditingController();
  final TextEditingController nController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final TextEditingController kController = TextEditingController();

  String recommendation = "";
  Map<String, int> nutrientLevels = {"N": 0, "P": 0, "K": 0};
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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
    phController.dispose();
    nController.dispose();
    pController.dispose();
    kController.dispose();
    super.dispose();
  }

  void analyzeSoil(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    double? ph = double.tryParse(phController.text);
    int? n = int.tryParse(nController.text);
    int? p = int.tryParse(pController.text);
    int? k = int.tryParse(kController.text);

    if (ph == null || n == null || p == null || k == null) {
      setState(() {
        recommendation = l10n.invalidValues;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.invalidValues),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    nutrientLevels = {"N": n, "P": p, "K": k};

    if (ph < 5.5) {
      recommendation = l10n.acidicSoil;
    } else if (ph > 7.5) {
      recommendation = l10n.alkalineSoil;
    } else {
      recommendation = l10n.goodSoil;
    }

    if (n < 50) recommendation += "\n${l10n.addN}";
    if (p < 50) recommendation += "\n${l10n.addP}";
    if (k < 50) recommendation += "\n${l10n.addK}";

    if (n >= 50 && p >= 50 && k >= 50) {
      recommendation += "\n${l10n.balancedNPK}";
    }

    setState(() {});
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: Color(0xFF4CAF50)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                      child: Icon(Icons.grass, color: Colors.white, size: 24),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.soilHealthTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Test & improve your soil',
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
            ),
          ),
          // Content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.science, color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 12),
                              Text(
                                l10n.enterValues,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: phController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(l10n.phLabel, Icons.water_drop),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: nController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(l10n.nLabel, Icons.science_outlined),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: pController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(l10n.pLabel, Icons.science_outlined),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: kController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(l10n.kLabel, Icons.science_outlined),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => analyzeSoil(context),
                              icon: Icon(Icons.analytics),
                              label: Text(l10n.analyzeButton),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chart Card
                    if (recommendation.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.bar_chart, color: Colors.white, size: 20),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Nutrient Levels',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 100,
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final titles = [l10n.nLabel, l10n.pLabel, l10n.kLabel];
                                          final text = titles[value.toInt()];
                                          return Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 25,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey[200]!,
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                          toY: nutrientLevels["N"]!.toDouble(),
                                          width: 30,
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                          toY: nutrientLevels["P"]!.toDouble(),
                                          width: 30,
                                          gradient: LinearGradient(
                                            colors: [Color(0xFFE53935), Color(0xFFEF5350)],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 2,
                                      barRods: [
                                        BarChartRodData(
                                          toY: nutrientLevels["K"]!.toDouble(),
                                          width: 30,
                                          gradient: LinearGradient(
                                            colors: [Color(0xFFFF9800), Color(0xFFFFA726)],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Recommendations Card
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.lightbulb, color: Colors.white, size: 20),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Recommendations',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF4CAF50).withAlpha(26),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                recommendation,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Best Practices Card
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.check_circle, color: Colors.white, size: 20),
                              ),
                              SizedBox(width: 12),
                              Text(
                                l10n.bestPractices,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          _buildPracticeItem(l10n.practice1),
                          _buildPracticeItem(l10n.practice2),
                          _buildPracticeItem(l10n.practice3),
                          _buildPracticeItem(l10n.practice4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 12),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../l10n/app_localizations.dart';

// class SoilHealthPage extends StatefulWidget {
//   const SoilHealthPage({super.key});

//   @override
//   State<SoilHealthPage> createState() => _SoilHealthPageState();
// }

// class _SoilHealthPageState extends State<SoilHealthPage> {
//   final TextEditingController phController = TextEditingController();
//   final TextEditingController nController = TextEditingController();
//   final TextEditingController pController = TextEditingController();
//   final TextEditingController kController = TextEditingController();

//   String recommendation = "";
//   Map<String, int> nutrientLevels = {"N": 0, "P": 0, "K": 0};

//   void analyzeSoil(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     double? ph = double.tryParse(phController.text);
//     int? n = int.tryParse(nController.text);
//     int? p = int.tryParse(pController.text);
//     int? k = int.tryParse(kController.text);

//     if (ph == null || n == null || p == null || k == null) {
//       setState(() {
//         recommendation = l10n.invalidValues;
//       });
//       return;
//     }

//     nutrientLevels = {"N": n, "P": p, "K": k};

//     if (ph < 5.5) {
//       recommendation = l10n.acidicSoil;
//     } else if (ph > 7.5) {
//       recommendation = l10n.alkalineSoil;
//     } else {
//       recommendation = l10n.goodSoil;
//     }

//     if (n < 50) recommendation += "\n${l10n.addN}";
//     if (p < 50) recommendation += "\n${l10n.addP}";
//     if (k < 50) recommendation += "\n${l10n.addK}";

//     if (n >= 50 && p >= 50 && k >= 50) {
//       recommendation += "\n${l10n.balancedNPK}";
//     }

//     setState(() {});
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: const OutlineInputBorder(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(l10n.soilHealthTitle),
//         backgroundColor: theme.colorScheme.primary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(l10n.enterValues,
//                 style: theme.textTheme.titleLarge),
//             const SizedBox(height: 12),
//             TextField(
//               controller: phController,
//               keyboardType: TextInputType.number,
//               decoration: _inputDecoration(l10n.phLabel),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: nController,
//               keyboardType: TextInputType.number,
//               decoration: _inputDecoration(l10n.nLabel),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: pController,
//               keyboardType: TextInputType.number,
//               decoration: _inputDecoration(l10n.pLabel),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: kController,
//               keyboardType: TextInputType.number,
//               decoration: _inputDecoration(l10n.kLabel),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: () => analyzeSoil(context),
//               icon: const Icon(Icons.science),
//               label: Text(l10n.analyzeButton),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: theme.colorScheme.primary,
//                 foregroundColor: theme.colorScheme.onPrimary,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Chart
//             if (recommendation.isNotEmpty)
//               SizedBox(
//                 height: 200,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceAround,
//                     maxY: 100,
//                     titlesData: FlTitlesData(
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: true, reservedSize: 28),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             final titles = [l10n.nLabel, l10n.pLabel, l10n.kLabel];
//                             final text = titles[value.toInt()];
//                             return SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(text, style: theme.textTheme.bodySmall),
//                             );
//                           },
//                         ),
//                       ),
//                       rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//                     borderData: FlBorderData(show: false),
//                     barGroups: [
//                       BarChartGroupData(
//                         x: 0,
//                         barRods: [
//                           BarChartRodData(
//                               toY: nutrientLevels["N"]!.toDouble(),
//                               width: 20,
//                               color: Colors.blue),
//                         ],
//                       ),
//                       BarChartGroupData(
//                         x: 1,
//                         barRods: [
//                           BarChartRodData(
//                               toY: nutrientLevels["P"]!.toDouble(),
//                               width: 20,
//                               color: Colors.red),
//                         ],
//                       ),
//                       BarChartGroupData(
//                         x: 2,
//                         barRods: [
//                           BarChartRodData(
//                               toY: nutrientLevels["K"]!.toDouble(),
//                               width: 20,
//                               color: Colors.orange),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 20),

//             // Recommendations
//             if (recommendation.isNotEmpty)
//               Card(
//                 color: theme.colorScheme.secondaryContainer,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Text(recommendation, style: theme.textTheme.bodyLarge),
//                 ),
//               ),
//             const SizedBox(height: 20),

//             // Best Practices
//             Text(l10n.bestPractices,
//                 style: theme.textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("• ${l10n.practice1}"),
//                     Text("• ${l10n.practice2}"),
//                     Text("• ${l10n.practice3}"),
//                     Text("• ${l10n.practice4}"),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
