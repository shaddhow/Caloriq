import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/meal_log_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/caloriq_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import 'food_logger_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProfileProvider>(context);
    final mealProvider = Provider.of<MealLogProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final metrics = userProvider.metrics;
    final totalEaten = mealProvider.totalKcal;
    final burned = mealProvider.caloriesBurned;
    final budget = metrics.budget;

    final suggestion = _MealSuggestion.fromCurrentTime();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CaloriqLogo(
                        size: 46,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good day',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          const Text(
                            'Rafi',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Streak Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A21) : AppTheme.card,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 18,
                          color: AppTheme.coral,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${mealProvider.streakDays} days',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. DARK HERO CARD (Calorie Ring + 3 Macro Progress Bars)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF26262F)
                      : const Color(0xFF15151B),
                  borderRadius: AppTheme.cardsBorderRadius,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily budget',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9A9AA6),
                          ),
                        ),
                        Text(
                          '$budget kcal',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Animated Calorie Ring
                    _CalorieRing(
                      eatenKcal: totalEaten,
                      budgetKcal: budget,
                      size: 196,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF9A9AA6),
                            ),
                            children: [
                              TextSpan(
                                text: '$totalEaten',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const TextSpan(text: ' eaten'),
                            ],
                          ),
                        ),
                        if (totalEaten > budget)
                          Text(
                            '+${totalEaten - budget} surplus',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.coral,
                            ),
                          )
                        else
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                color: Color(0xFF9A9AA6),
                              ),
                              children: [
                                TextSpan(
                                  text: '$burned',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const TextSpan(text: ' burned'),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFF2E2E38), height: 1),
                    const SizedBox(height: 16),

                    // 3 Macro Targets vs Consumed (Protein, Carbs, Fat)
                    Row(
                      children: [
                        _buildMacroColumn(
                          label: 'PROTEIN',
                          consumed: mealProvider.totalProtein.round(),
                          target: (budget * 0.30 / 4).round(),
                          color: const Color(0xFFFF725E),
                        ),
                        const SizedBox(width: 14),
                        _buildMacroColumn(
                          label: 'CARBS',
                          consumed: mealProvider.totalCarbs.round(),
                          target: (budget * 0.45 / 4).round(),
                          color: const Color(0xFFF5B842),
                        ),
                        const SizedBox(width: 14),
                        _buildMacroColumn(
                          label: 'FAT',
                          consumed: mealProvider.totalFat.round(),
                          target: (budget * 0.25 / 9).round(),
                          color: const Color(0xFF56C5C5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. BENTO GRID (Water Tracker & Daily Weigh-in)
              Row(
                children: [
                  // Water Tracker Card
                  Expanded(
                    child: _buildWaterCard(context, mealProvider, isDark),
                  ),
                  const SizedBox(width: 12),

                  // Daily Weight Card
                  Expanded(
                    child: _buildWeightCard(
                      context,
                      userProvider,
                      mealProvider,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // 4. TODAY'S MEALS BREAKDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's meals",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    '${mealProvider.loggedToday.length} items logged',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4 Meal Slots: Breakfast, Lunch, Snacks, Dinner
              _buildMealSlotTile(
                context: context,
                mealName: 'Breakfast',
                icon: Icons.wb_sunny_outlined,
                calories: mealProvider.getCaloriesForMeal('Breakfast'),
                items: mealProvider.getItemsForMeal('Breakfast'),
                isDark: isDark,
              ),
              const SizedBox(height: 10),

              _buildMealSlotTile(
                context: context,
                mealName: 'Lunch',
                icon: Icons.wb_sunny_rounded,
                calories: mealProvider.getCaloriesForMeal('Lunch'),
                items: mealProvider.getItemsForMeal('Lunch'),
                isDark: isDark,
              ),
              const SizedBox(height: 10),

              _buildMealSlotTile(
                context: context,
                mealName: 'Snacks',
                icon: Icons.coffee_rounded,
                calories: mealProvider.getCaloriesForMeal('Snacks'),
                items: mealProvider.getItemsForMeal('Snacks'),
                isDark: isDark,
              ),
              const SizedBox(height: 10),

              _buildMealSlotTile(
                context: context,
                mealName: 'Dinner',
                icon: Icons.nightlight_round,
                calories: mealProvider.getCaloriesForMeal('Dinner'),
                items: mealProvider.getItemsForMeal('Dinner'),
                isDark: isDark,
              ),
              const SizedBox(height: 18),

              // 5. "EAT NEXT" SUGGESTION CARD (Lime Accent)
              CustomCard(
                backgroundColor: AppTheme.lime,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: AppTheme.ink,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'EAT NEXT · ${suggestion.mealType.toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.6,
                            color: AppTheme.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      suggestion.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggestion.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xB314141A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Log meal',
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FoodLoggerScreen(
                              initialMealType: suggestion.mealType,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Bottom padding for floating nav bar
            ],
          ),
        ),
      ),
    );
  }

  // Macro Column Builder
  static Widget _buildMacroColumn({
    required String label,
    required int consumed,
    required int target,
    required Color color,
  }) {
    final double progress =
        target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF9A9AA6),
                ),
              ),
              Text(
                '${consumed}g',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Stack(
              children: [
                Container(
                  height: 5,
                  width: double.infinity,
                  color: const Color(0xFF2E2E38),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Target ${target}g',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7A88),
            ),
          ),
        ],
      ),
    );
  }

  // Water Tracker Card
  static Widget _buildWaterCard(
    BuildContext context,
    MealLogProvider mealProvider,
    bool isDark,
  ) {
    final double waterRatio =
        (mealProvider.waterMl / mealProvider.waterTargetMl).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2830) : const Color(0xFFEBF5FA),
        borderRadius: AppTheme.cardsBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isDark ? Colors.white : AppTheme.ink,
                ),
              ),
              const Icon(
                Icons.water_drop_rounded,
                size: 20,
                color: Color(0xFF1E88E5),
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
                  text: '${mealProvider.waterMl}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: ' ml',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Target: ${mealProvider.waterTargetMl} ml',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 10),

          // Mini progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Stack(
              children: [
                Container(
                  height: 5,
                  width: double.infinity,
                  color: isDark
                      ? const Color(0xFF2A3642)
                      : const Color(0xFFD6E9F5),
                ),
                FractionallySizedBox(
                  widthFactor: waterRatio,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Interactive +250ml quick action button
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    mealProvider.addWater(250);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Center(
                      child: Text(
                        '+ 250 ml',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (mealProvider.waterMl > 0) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    mealProvider.removeWater(250);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A3642)
                          : const Color(0xFFD6E9F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: isDark ? Colors.white : AppTheme.ink,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Daily Weigh-in Card
  static Widget _buildWeightCard(
    BuildContext context,
    UserProfileProvider userProvider,
    MealLogProvider mealProvider,
    bool isDark,
  ) {
    final currentWeight =
        mealProvider.todayWeight ?? userProvider.profile.weight;
    final metrics = userProvider.metrics;

    return GestureDetector(
      onTap: () => _showWeightBottomSheet(
        context,
        userProvider,
        mealProvider,
        currentWeight,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF28201D) : const Color(0xFFFFF2EB),
          borderRadius: AppTheme.cardsBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : AppTheme.ink,
                  ),
                ),
                const Icon(
                  Icons.monitor_weight_outlined,
                  size: 20,
                  color: Color(0xFFE67E42),
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
                    text: currentWeight.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      height: 1.0,
                    ),
                  ),
                  TextSpan(
                    text: ' kg',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'BMI ${metrics.bmi} · ${metrics.bmiCategory}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 10),

            // Subtle indicator
            Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE67E42).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),

            // Tap to log weight pill button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE67E42),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Log weight',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Weight Bottom Sheet Modal
  static void _showWeightBottomSheet(
    BuildContext context,
    UserProfileProvider userProvider,
    MealLogProvider mealProvider,
    double initialWeight,
  ) {
    double selectedWeight = initialWeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E26) : Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Log today\'s weight',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C2C38)
                                : const Color(0xFFF1EFEA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: isDark ? Colors.white : AppTheme.ink,
                        ),
                        children: [
                          TextSpan(
                            text: selectedWeight.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const TextSpan(
                            text: ' kg',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Slider(
                    value: selectedWeight.clamp(40.0, 180.0),
                    min: 40.0,
                    max: 180.0,
                    divisions: 280,
                    activeColor: const Color(0xFFE67E42),
                    inactiveColor: isDark
                        ? const Color(0xFF33333F)
                        : const Color(0xFFEBE8E1),
                    onChanged: (val) {
                      setModalState(() {
                        selectedWeight =
                            double.parse(val.toStringAsFixed(1));
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Save weight',
                    onPressed: () {
                      mealProvider.setTodayWeight(selectedWeight);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Weight recorded: ${selectedWeight.toStringAsFixed(1)} kg',
                          ),
                          backgroundColor: AppTheme.ink,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Meal Slot Tile
  static Widget _buildMealSlotTile({
    required BuildContext context,
    required String mealName,
    required IconData icon,
    required int calories,
    required List<FoodItem> items,
    required bool isDark,
  }) {
    final bool hasLogs = calories > 0;
    final itemsSummary = items.map((e) => e.name).join(', ');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FoodLoggerScreen(initialMealType: mealName),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E26) : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF2C2C38) : const Color(0xFFEFECE6),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasLogs
                    ? AppTheme.lime.withValues(alpha: 0.25)
                    : (isDark
                        ? const Color(0xFF2A2A35)
                        : const Color(0xFFF1EFEA)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: hasLogs ? AppTheme.ink : Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mealName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        hasLogs ? '$calories kcal' : '0 kcal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              hasLogs ? FontWeight.w700 : FontWeight.w500,
                          color: hasLogs
                              ? (isDark ? Colors.white : AppTheme.ink)
                              : Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasLogs
                        ? itemsSummary
                        : 'Not logged yet · Tap to add',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: hasLogs
                    ? (isDark
                        ? const Color(0xFF2C2C38)
                        : const Color(0xFFF1EFEA))
                    : AppTheme.lime,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasLogs ? Icons.chevron_right : Icons.add,
                size: 16,
                color: AppTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Meal Suggestion Helper
class _MealSuggestion {
  final String mealType;
  final String title;
  final String subtitle;

  const _MealSuggestion({
    required this.mealType,
    required this.title,
    required this.subtitle,
  });

  factory _MealSuggestion.fromCurrentTime() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return const _MealSuggestion(
        mealType: 'Breakfast',
        title: 'Greek yogurt, oats & banana',
        subtitle: '320 kcal · 22g protein',
      );
    } else if (hour < 16) {
      return const _MealSuggestion(
        mealType: 'Lunch',
        title: 'Rice, dal & grilled fish',
        subtitle: '560 kcal · 34g protein',
      );
    } else if (hour < 19) {
      return const _MealSuggestion(
        mealType: 'Snacks',
        title: 'Roasted chickpeas & tea',
        subtitle: '150 kcal · 8g protein',
      );
    } else {
      return const _MealSuggestion(
        mealType: 'Dinner',
        title: '2 Ruti, veg bhaji & chicken',
        subtitle: '480 kcal · 36g protein',
      );
    }
  }
}

// Circular Ring Painter Widget with Load Animation
class _CalorieRing extends StatefulWidget {
  final int eatenKcal;
  final int budgetKcal;
  final double size;

  const _CalorieRing({
    required this.eatenKcal,
    required this.budgetKcal,
    this.size = 196,
  });

  @override
  State<_CalorieRing> createState() => _CalorieRingState();
}

class _CalorieRingState extends State<_CalorieRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _CalorieRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eatenKcal != widget.eatenKcal ||
        oldWidget.budgetKcal != widget.budgetKcal) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.budgetKcal - widget.eatenKcal;
    final isSurplus = remaining < 0;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _CalorieRingPainter(
                  eatenKcal: widget.eatenKcal,
                  budgetKcal: widget.budgetKcal,
                  progress: _animation.value,
                  strokeWidth: 14.0,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${isSurplus ? remaining.abs() : remaining}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSurplus ? 'kcal over' : 'kcal left',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSurplus
                          ? AppTheme.coral
                          : const Color(0xFF9A9AA6),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// Custom Painter for Calorie Ring Arc
class _CalorieRingPainter extends CustomPainter {
  final int eatenKcal;
  final int budgetKcal;
  final double progress;
  final double strokeWidth;

  _CalorieRingPainter({
    required this.eatenKcal,
    required this.budgetKcal,
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background Track
    final trackPaint = Paint()
      ..color = const Color(0xFF2A2A33)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active Arc
    final double ratio = budgetKcal > 0
        ? (eatenKcal / budgetKcal).clamp(0.0, 1.0)
        : 0.0;
    final double sweepAngle = 2 * 3.1415926535 * ratio * progress;
    const double startAngle = -3.1415926535 / 2;

    final isSurplus = eatenKcal > budgetKcal;
    final activePaint = Paint()
      ..color = isSurplus ? AppTheme.coral : AppTheme.lime
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (sweepAngle > 0.01) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return oldDelegate.eatenKcal != eatenKcal ||
        oldDelegate.budgetKcal != budgetKcal ||
        oldDelegate.progress != progress;
  }
}
