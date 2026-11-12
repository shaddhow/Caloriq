import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/meal_provider.dart';
import '../utils/app_theme.dart';
import '../utils/food_data.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class FoodLoggerScreen extends StatefulWidget {
  final String? initialMealType;

  const FoodLoggerScreen({super.key, this.initialMealType});

  @override
  State<FoodLoggerScreen> createState() => _FoodLoggerScreenState();
}

class _FoodLoggerScreenState extends State<FoodLoggerScreen> {
  late String _selectedTab;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<FoodItem> _loggedSessionItems = [];

  final List<String> _mealTabs = const [
    'Breakfast',
    'Lunch',
    'Snacks',
    'Dinner',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialMealType ?? 'Breakfast';
    if (!_mealTabs.contains(_selectedTab)) {
      _selectedTab = 'Breakfast';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Macro Totals
  int get _totalKcal =>
      _loggedSessionItems.fold(0, (sum, item) => sum + item.kcal);
  double get _totalCarbs =>
      _loggedSessionItems.fold(0.0, (sum, item) => sum + item.carbs);
  double get _totalProtein =>
      _loggedSessionItems.fold(0.0, (sum, item) => sum + item.protein);
  double get _totalFat =>
      _loggedSessionItems.fold(0.0, (sum, item) => sum + item.fat);

  double get _carbsKcal => _totalCarbs * 4.0;
  double get _proteinKcal => _totalProtein * 4.0;
  double get _fatKcal => _totalFat * 9.0;
  double get _totalMacroKcal => _carbsKcal + _proteinKcal + _fatKcal;

  int get _carbsPercent => _totalMacroKcal > 0
      ? ((_carbsKcal / _totalMacroKcal) * 100).round()
      : 0;
  int get _proteinPercent => _totalMacroKcal > 0
      ? ((_proteinKcal / _totalMacroKcal) * 100).round()
      : 0;
  int get _fatPercent => _totalMacroKcal > 0
      ? ((_fatKcal / _totalMacroKcal) * 100).round()
      : 0;

  void _addFoodItem(FoodItem item) {
    setState(() {
      _loggedSessionItems.add(item);
    });
  }

  void _removeFoodItem(int index) {
    setState(() {
      _loggedSessionItems.removeAt(index);
    });
  }

  void _saveMealLogs() {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    for (final item in _loggedSessionItems) {
      mealProvider.addLoggedItem(item.copyWith(mealType: _selectedTab));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved ${_loggedSessionItems.length} items to $_selectedTab'),
        backgroundColor: AppTheme.ink,
        duration: const Duration(seconds: 2),
      ),
    );

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _loggedSessionItems.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foodDatabase = FoodData.defaultFoodDatabase;
    final currentOptions = foodDatabase[_selectedTab] ?? [];

    // Search filter
    final filteredOptions = currentOptions.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER ROW ("Log meal" + "Close" button)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Log meal',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1A1A21)
                                  : AppTheme.card,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppTheme.ink,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 2. HORIZONTAL SCROLLABLE TAB PILLS
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _mealTabs.map((tab) {
                          final isSelected = _selectedTab == tab;
                          final pillBg = isSelected
                              ? (isDark ? Colors.white : AppTheme.ink)
                              : (isDark
                                  ? const Color(0xFF1A1A21)
                                  : AppTheme.card);
                          final pillFg = isSelected
                              ? (isDark ? AppTheme.ink : Colors.white)
                              : (isDark ? Colors.white : AppTheme.ink);

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTab = tab;
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  color: pillBg,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  tab,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: pillFg,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. SEARCH BAR
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : AppTheme.ink,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search rice, dal, hilsa…',
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor:
                            isDark ? const Color(0xFF1A1A21) : AppTheme.card,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. "QUICK PORTIONS" SECTION
                    Text(
                      'Quick portions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filteredOptions.map((food) {
                        return GestureDetector(
                          onTap: () => _addFoodItem(food),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1A1A21)
                                  : AppTheme.card,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppTheme.ink,
                                ),
                                children: [
                                  TextSpan(text: '+ ${food.name} '),
                                  TextSpan(
                                    text: '${food.kcal}',
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // 5. MEAL SUMMARY CARD
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'This meal',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color:
                                        isDark ? Colors.white : AppTheme.ink,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$_totalKcal ',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'kcal',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Segmented Macro Bar
                          _MacroSegmentBar(
                            carbsPercent: _carbsPercent,
                            proteinPercent: _proteinPercent,
                            fatPercent: _fatPercent,
                          ),
                          const SizedBox(height: 10),

                          // Macro Legend Percentages
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMacroLegend(
                                label: 'Carbs',
                                percent: _carbsPercent,
                                color: AppTheme.lime,
                              ),
                              _buildMacroLegend(
                                label: 'Protein',
                                percent: _proteinPercent,
                                color: const Color(0xFFA78BFA),
                              ),
                              _buildMacroLegend(
                                label: 'Fat',
                                percent: _fatPercent,
                                color: const Color(0xFFFF9B71),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          const Divider(height: 1),
                          const SizedBox(height: 10),

                          // Logged Items List
                          if (_loggedSessionItems.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Tap a portion to add it.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _loggedSessionItems.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = _loggedSessionItems[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${item.kcal} kcal',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => _removeFoodItem(index),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 6. BOTTOM "SAVE TO [TAB]" BUTTON
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: Navigator.of(context).canPop() ? 16 : 96,
              ),
              child: CustomButton(
                text: 'Save to $_selectedTab',
                onPressed: _saveMealLogs,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroLegend({
    required String label,
    required int percent,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '$label $percent%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}

// Colored Macro Segmented Bar
class _MacroSegmentBar extends StatelessWidget {
  final int carbsPercent;
  final int proteinPercent;
  final int fatPercent;

  const _MacroSegmentBar({
    required this.carbsPercent,
    required this.proteinPercent,
    required this.fatPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? const Color(0xFF2A2A33) : const Color(0xFFE9E6DF);

    final total = carbsPercent + proteinPercent + fatPercent;

    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(9),
      ),
      clipBehavior: Clip.antiAlias,
      child: total == 0
          ? Container(color: trackColor)
          : Row(
              children: [
                if (carbsPercent > 0)
                  Expanded(
                    flex: carbsPercent,
                    child: Container(color: AppTheme.lime),
                  ),
                if (proteinPercent > 0)
                  Expanded(
                    flex: proteinPercent,
                    child: Container(color: const Color(0xFFA78BFA)),
                  ),
                if (fatPercent > 0)
                  Expanded(
                    flex: fatPercent,
                    child: Container(color: const Color(0xFFFF9B71)),
                  ),
              ],
            ),
    );
  }
}
