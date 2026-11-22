import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_log_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/glassy_badge.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isCloudSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final mealProvider = Provider.of<MealLogProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final profile = userProvider.profile;
    final metrics = userProvider.metrics;

    // Dynamic 7-day weight trend centered around user's actual profile weight
    final rawWeights = mealProvider.getWeightTrend(profile.weight);
    final movingAverages = List.generate(rawWeights.length, (i) {
      final subList = rawWeights.sublist(i >= 2 ? i - 2 : 0, i + 1);
      return subList.reduce((a, b) => a + b) / subList.length;
    });

    final currentAverageWeight = movingAverages.last;
    final minWeight = rawWeights.reduce((a, b) => a < b ? a : b) - 1.0;
    final maxWeight = rawWeights.reduce((a, b) => a > b ? a : b) + 1.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TITLE & SUBTITLE
              const Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Last 7 days',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 18),

              // 2. WEIGHT TREND CARD (3-day moving average chart)
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight · 3-day average',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lime,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text(
                            '−1.0 kg',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: isDark ? Colors.white : AppTheme.ink,
                        ),
                        children: [
                          TextSpan(
                            text: currentAverageWeight.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          TextSpan(
                            text: ' kg',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // fl_chart Line Chart
                    SizedBox(
                      height: 160,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  final index = value.toInt();
                                  if (index >= 0 && index < days.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        days[index],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          minY: minWeight,
                          maxY: maxWeight,
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                movingAverages.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  movingAverages[index],
                                ),
                              ),
                              isCurved: true,
                              color: isDark ? Colors.white : AppTheme.ink,
                              barWidth: 3.5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) =>
                                    spot.x == movingAverages.length - 1,
                                getDotPainter:
                                    (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: AppTheme.lime,
                                    strokeWidth: 3.5,
                                    strokeColor:
                                        isDark ? Colors.white : AppTheme.ink,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppTheme.lime.withValues(alpha: 0.5),
                                    AppTheme.lime.withValues(alpha: 0.0),
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
              const SizedBox(height: 12),

              // 3. CHEAT DAY COMPENSATOR CARD (Ultra-Luxury Telemetry)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF221715) : const Color(0xFFFFF4EE),
                  borderRadius: AppTheme.cardsBorderRadius,
                  border: Border.all(
                    color: isDark ? const Color(0xFF38231E) : const Color(0xFFFCDDCD),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B4A).withValues(alpha: isDark ? 0.15 : 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GlassyBadge.flame(size: 26),
                        const SizedBox(width: 8),
                        Text(
                          'CHEAT DAY COMPENSATOR',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: isDark ? const Color(0xFFFF8B70) : const Color(0xFFD35400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '+800 kcal yesterday',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppTheme.ink,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Spread across the next 48 hours. No guilt, just math.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFFB8A6A2) : const Color(0xFF7A6A66),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Two Mini Cards for Today & Tomorrow
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C1E1B) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF3F2B26)
                                    : const Color(0xFFF5E4DC),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFFA0908C) : const Color(0xFF8A7A76),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${metrics.budget - 400}',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : AppTheme.ink,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C1E1B) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF3F2B26)
                                    : const Color(0xFFF5E4DC),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tomorrow',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFFA0908C) : const Color(0xFF8A7A76),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${metrics.budget - 400}',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : AppTheme.ink,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. CLOUD SYNC & STATS LIST CARD
              CustomCard(
                child: Column(
                  children: [
                    // Cloud Sync Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppTheme.sky,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.cloud_outlined,
                                color: AppTheme.ink,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cloud sync',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Synced 2 min ago',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Toggle switch
                        Switch(
                          value: _isCloudSyncEnabled,
                          activeThumbColor: AppTheme.ink,
                          activeTrackColor: AppTheme.lime,
                          onChanged: (val) {
                            setState(() {
                              _isCloudSyncEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 6),

                    // User Profile Stats List
                    _buildStatRow(
                      context,
                      label: 'Goal',
                      value: profile.goal,
                    ),
                    const Divider(height: 1),
                    _buildStatRow(
                      context,
                      label: 'Weight',
                      value: '${profile.weight.round()} kg',
                    ),
                    const Divider(height: 1),
                    _buildStatRow(
                      context,
                      label: 'Activity',
                      value: profile.activityLevel,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
