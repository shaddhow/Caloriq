import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/meal_log_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/app_theme.dart';
import '../utils/food_data.dart';
import '../widgets/caloriq_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/glassy_badge.dart';
import 'ai_food_scanner_screen.dart';
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

    final suggestion = _MealSuggestion.determineNextMeal(
      mealProvider: mealProvider,
      cuisine: userProvider.cuisine,
      budget: budget,
    );

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

                  // Luxury Glass Streak Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E28) : Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2C2C3A)
                            : const Color(0xFFEBE8E1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B4A).withValues(alpha: isDark ? 0.2 : 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GlassyBadge.flame(size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '${mealProvider.streakDays} days',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: isDark ? Colors.white : AppTheme.ink,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. ULTRA-PREMIUM TELEMETRY HERO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF191922) : Colors.white,
                  borderRadius: AppTheme.cardsBorderRadius,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2C2C3A)
                        : const Color(0xFFECE9E2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.35 : 0.04,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.02,
                      ),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Telemetry Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.lime,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'DAILY BUDGET',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: isDark
                                    ? const Color(0xFF9A9AA6)
                                    : const Color(0xFF7A7A88),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF242430)
                                : const Color(0xFFF4F3EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$budget kcal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppTheme.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Animated Calorie Ring with SweepGradient Arc
                    _CalorieRing(
                      eatenKcal: totalEaten,
                      budgetKcal: budget,
                      size: 204,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 18),

                    // Metric Chips Row (Eaten & Burned Telemetry)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Eaten Chip
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF22222D)
                                  : const Color(0xFFF6F5F0),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF2E2E3C)
                                    : const Color(0xFFECE9E2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.restaurant_rounded,
                                  size: 13,
                                  color: Color(0xFF8A8A98),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        color: isDark
                                            ? const Color(0xFF9A9AA6)
                                            : const Color(0xFF6E6E7C),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '$totalEaten',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: isDark
                                                ? Colors.white
                                                : AppTheme.ink,
                                          ),
                                        ),
                                        const TextSpan(text: ' eaten'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Burned / Surplus Chip
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF22222D)
                                  : const Color(0xFFF6F5F0),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF2E2E3C)
                                    : const Color(0xFFECE9E2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  totalEaten > budget
                                      ? Icons.warning_amber_rounded
                                      : Icons.local_fire_department_rounded,
                                  size: 14,
                                  color: totalEaten > budget
                                      ? AppTheme.coral
                                      : const Color(0xFFFF8A3D),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: totalEaten > budget
                                      ? Text(
                                          '+${totalEaten - budget} surplus',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.coral,
                                          ),
                                        )
                                      : RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 12,
                                              color: isDark
                                                  ? const Color(0xFF9A9AA6)
                                                  : const Color(0xFF6E6E7C),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '$burned',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: isDark
                                                      ? Colors.white
                                                      : AppTheme.ink,
                                                ),
                                              ),
                                              const TextSpan(text: ' burned'),
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

                    const SizedBox(height: 18),

                    // 3 Macro Telemetry Pods (Protein, Carbs, Fat)
                    Row(
                      children: [
                        _buildMacroColumn(
                          label: 'PROTEIN',
                          consumed: mealProvider.totalProtein.round(),
                          target: (budget * 0.30 / 4).round(),
                          color: const Color(0xFFFF6554),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildMacroColumn(
                          label: 'CARBS',
                          consumed: mealProvider.totalCarbs.round(),
                          target: (budget * 0.45 / 4).round(),
                          color: const Color(0xFFF5A623),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildMacroColumn(
                          label: 'FAT',
                          consumed: mealProvider.totalFat.round(),
                          target: (budget * 0.25 / 9).round(),
                          color: const Color(0xFF2AC4B3),
                          isDark: isDark,
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AiFoodScannerScreen(),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.lime.withValues(alpha: 0.18)
                                : AppTheme.lime,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                size: 14,
                                color: isDark ? AppTheme.lime : AppTheme.ink,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'AI Scan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  color: isDark ? AppTheme.lime : AppTheme.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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

              // 5. "EAT NEXT" SUGGESTION CARD
              CustomCard(
                backgroundColor:
                    isDark ? const Color(0xFF1F1F27) : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.lime.withValues(alpha: 0.18)
                                : AppTheme.lime,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                suggestion.isAllCompleted
                                    ? Icons.nightlight_round
                                    : Icons.eco_rounded,
                                size: 14,
                                color: isDark ? AppTheme.lime : AppTheme.ink,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                suggestion.tag,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                  color: isDark ? AppTheme.lime : AppTheme.ink,
                                ),
                              ),
                              if (FoodData.cuisineFlags[suggestion.cuisine] != null &&
                                  !suggestion.isAllCompleted) ...[
                                const SizedBox(width: 6),
                                GlassyBadge.flag(
                                  FoodData.cuisineFlags[suggestion.cuisine]!,
                                  size: 20,
                                  fontSize: 12,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (!suggestion.isAllCompleted && suggestion.remainingBudget > 0) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF262635)
                                  : const Color(0xFFF1EFE8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${suggestion.remainingBudget} kcal left',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? const Color(0xFFD4FF66)
                                    : const Color(0xFF38690D),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      suggestion.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppTheme.ink,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggestion.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    if (suggestion.swapTip.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF222B1B)
                              : const Color(0xFFF3FAEC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.lime.withValues(
                              alpha: isDark ? 0.35 : 0.65,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.swap_horizontal_circle_outlined,
                                  color: AppTheme.lime,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'VOLUME HACK · EAT MORE, WEIGH LESS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                    letterSpacing: 0.4,
                                    color: isDark
                                        ? AppTheme.lime
                                        : const Color(0xFF38690D),
                                  ),
                                ),
                                const Spacer(),
                                if (suggestion.savingsKcal > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lime,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '-${suggestion.savingsKcal} kcal',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.ink,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              suggestion.swapTip,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFD6D6DE)
                                    : const Color(0xFF4A5538),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    CustomButton(
                      text: suggestion.isAllCompleted
                          ? 'Log extra food'
                          : 'Log ${suggestion.mealType.toLowerCase()}',
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FoodLoggerScreen(
                              initialMealType: suggestion.isAllCompleted
                                  ? 'Snacks'
                                  : suggestion.mealType,
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

  // Macro Column Builder as Sleek Telemetry Pods
  static Widget _buildMacroColumn({
    required String label,
    required int consumed,
    required int target,
    required Color color,
    required bool isDark,
  }) {
    final double progress =
        target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF20202A) : const Color(0xFFF7F6F1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2B2B38) : const Color(0xFFECE9E2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: isDark
                            ? const Color(0xFF9A9AA6)
                            : const Color(0xFF7A7A88),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${consumed}g',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppTheme.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Stack(
                children: [
                  Container(
                    height: 5,
                    width: double.infinity,
                    color: isDark
                        ? const Color(0xFF2B2B38)
                        : const Color(0xFFE5E2D9),
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
            const SizedBox(height: 5),
            Text(
              'Target ${target}g',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF7A7A88)
                    : const Color(0xFF90909E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Water Tracker Card (Ultra-Premium Glassy Bento)
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
        color: isDark ? const Color(0xFF161C26) : Colors.white,
        borderRadius: AppTheme.cardsBorderRadius,
        border: Border.all(
          color: isDark ? const Color(0xFF222C3D) : const Color(0xFFE5EEF5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
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
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isDark ? Colors.white : AppTheme.ink,
                ),
              ),
              GlassyBadge(
                size: 28,
                borderRadius: 8,
                glowColor: const Color(0xFF0288D1).withValues(alpha: 0.3),
                child: const Icon(
                  Icons.water_drop_rounded,
                  size: 16,
                  color: Color(0xFF29B6F6),
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
                      ? const Color(0xFF232D3B)
                      : const Color(0xFFE3EDF5),
                ),
                FractionallySizedBox(
                  widthFactor: waterRatio,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0288D1), Color(0xFF29B6F6)],
                      ),
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
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0288D1), Color(0xFF039BE5)],
                      ),
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0288D1).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF232D3B)
                          : const Color(0xFFE8EEF4),
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

  // Daily Weigh-in Card (Ultra-Premium Glassy Bento)
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF221A16) : Colors.white,
          borderRadius: AppTheme.cardsBorderRadius,
          border: Border.all(
            color: isDark ? const Color(0xFF38261F) : const Color(0xFFF7EBE4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE67E42).withValues(alpha: isDark ? 0.15 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
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
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? Colors.white : AppTheme.ink,
                  ),
                ),
                GlassyBadge(
                  size: 28,
                  borderRadius: 8,
                  glowColor: const Color(0xFFE67E42).withValues(alpha: 0.3),
                  child: const Icon(
                    Icons.monitor_weight_outlined,
                    size: 16,
                    color: Color(0xFFE67E42),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFFE67E42), Color(0xFFFF9E6B)],
                ),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),

            // Tap to log weight pill button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE67E42), Color(0xFFF18C52)],
                ),
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE67E42).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
  final String tag;
  final String mealType;
  final String title;
  final String subtitle;
  final String cuisine;
  final String swapTip;
  final int savingsKcal;
  final int remainingBudget;
  final bool isAllCompleted;

  const _MealSuggestion({
    required this.tag,
    required this.mealType,
    required this.title,
    required this.subtitle,
    required this.cuisine,
    required this.swapTip,
    this.savingsKcal = 0,
    this.remainingBudget = 0,
    this.isAllCompleted = false,
  });

  factory _MealSuggestion.determineNextMeal({
    required MealLogProvider mealProvider,
    required String cuisine,
    required int budget,
  }) {
    final hasBreakfast = mealProvider.getCaloriesForMeal('Breakfast') > 0 ||
        mealProvider.getItemsForMeal('Breakfast').isNotEmpty;
    final hasLunch = mealProvider.getCaloriesForMeal('Lunch') > 0 ||
        mealProvider.getItemsForMeal('Lunch').isNotEmpty;
    final hasSnacks = mealProvider.getCaloriesForMeal('Snacks') > 0 ||
        mealProvider.getItemsForMeal('Snacks').isNotEmpty;
    final hasDinner = mealProvider.getCaloriesForMeal('Dinner') > 0 ||
        mealProvider.getItemsForMeal('Dinner').isNotEmpty;

    final hour = DateTime.now().hour;
    final remainingBudget = (budget - mealProvider.totalKcal).clamp(0, 9999);

    String mealType;
    String tag;
    bool isAllCompleted = false;

    if (!hasBreakfast && hour < 11) {
      mealType = 'Breakfast';
      tag = 'HEALTHY CHOICE · BREAKFAST';
    } else if (!hasLunch && (hasBreakfast || hour >= 11) && hour < 16) {
      mealType = 'Lunch';
      tag = 'UP NEXT · LUNCH';
    } else if (!hasSnacks && (hasLunch || hour >= 16) && hour < 19) {
      mealType = 'Snacks';
      tag = 'UP NEXT · SNACKS';
    } else if (!hasDinner) {
      mealType = 'Dinner';
      tag = 'UP NEXT · DINNER';
    } else if (!hasSnacks) {
      mealType = 'Snacks';
      tag = 'HEALTHY CHOICE · SNACKS';
    } else if (!hasLunch) {
      mealType = 'Lunch';
      tag = 'HEALTHY CHOICE · LUNCH';
    } else if (!hasBreakfast) {
      mealType = 'Breakfast';
      tag = 'HEALTHY CHOICE · BREAKFAST';
    } else {
      mealType = 'Recovery';
      tag = 'ALL MEALS LOGGED · REST & HYDRATION';
      isAllCompleted = true;
    }

    final data = FoodData.getSuggestion(
      mealType: mealType,
      cuisine: cuisine,
    );

    return _MealSuggestion(
      tag: tag,
      mealType: mealType,
      title: data.title,
      subtitle: data.subtitle,
      cuisine: cuisine,
      swapTip: data.swapTip,
      savingsKcal: data.savingsKcal,
      remainingBudget: remainingBudget,
      isAllCompleted: isAllCompleted,
    );
  }
}

// Circular Ring Painter Widget with Load Animation
class _CalorieRing extends StatefulWidget {
  final int eatenKcal;
  final int budgetKcal;
  final double size;
  final bool isDark;

  const _CalorieRing({
    required this.eatenKcal,
    required this.budgetKcal,
    this.size = 196,
    this.isDark = true,
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
        oldWidget.budgetKcal != widget.budgetKcal ||
        oldWidget.isDark != widget.isDark) {
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
                  strokeWidth: 15.0,
                  isDark: widget.isDark,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${isSurplus ? remaining.abs() : remaining}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.8,
                      color: widget.isDark ? Colors.white : AppTheme.ink,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isSurplus
                          ? AppTheme.coral.withValues(alpha: 0.12)
                          : (widget.isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFF1EFEA)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isSurplus ? 'KCAL OVER' : 'KCAL LEFT',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isSurplus
                            ? AppTheme.coral
                            : (widget.isDark
                                ? const Color(0xFFB0B0BE)
                                : const Color(0xFF6E6E7C)),
                      ),
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

// Custom Painter for Calorie Ring Arc with SweepGradient
class _CalorieRingPainter extends CustomPainter {
  final int eatenKcal;
  final int budgetKcal;
  final double progress;
  final double strokeWidth;
  final bool isDark;

  _CalorieRingPainter({
    required this.eatenKcal,
    required this.budgetKcal,
    required this.progress,
    required this.strokeWidth,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background Track (Smooth Silky Base)
    final trackPaint = Paint()
      ..color = isDark ? const Color(0xFF252532) : const Color(0xFFEFECE5)
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
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (sweepAngle > 0.01) {
      if (isSurplus) {
        activePaint.color = AppTheme.coral;
      } else {
        activePaint.shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: isDark
              ? const [Color(0xFFD4FF66), Color(0xFF8CE615)]
              : const [Color(0xFFB2F042), Color(0xFF6CD410)],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      }

      // Soft ambient glow under arc in dark mode
      if (isDark) {
        final glowPaint = Paint()
          ..color = (isSurplus ? AppTheme.coral : AppTheme.lime)
              .withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          glowPaint,
        );
      }

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
        oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark;
  }
}
