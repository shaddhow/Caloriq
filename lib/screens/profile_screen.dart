import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart';
import '../utils/food_data.dart';
import '../widgets/caloriq_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/glassy_badge.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final profile = userProvider.profile;
    final metrics = userProvider.metrics;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile & Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  CaloriqLogo(
                    size: 42,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // User Card
              CustomCard(
                backgroundColor:
                    isDark ? const Color(0xFF26262F) : AppTheme.ink,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppTheme.lime,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.ink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authProvider.userDisplayName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                authProvider.userEmail.isNotEmpty
                                    ? authProvider.userEmail
                                    : '${profile.gender} · ${profile.age} yrs',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF9A9AA6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0x26FFFFFF), height: 1),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileStat('BMI', '${metrics.bmi}'),
                        _buildProfileStat('TDEE', '${metrics.tdee} kcal'),
                        _buildProfileStat('Budget', '${metrics.budget} kcal'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Settings Card
              CustomCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              themeNotifier.isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: themeNotifier.isDarkMode,
                          activeThumbColor: AppTheme.ink,
                          activeTrackColor: AppTheme.lime,
                          onChanged: (_) => themeNotifier.toggleTheme(),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildSettingItem(
                      icon: Icons.height,
                      title: 'Height & Weight',
                      subtitle:
                          '${profile.height.round()} cm · ${profile.weight.round()} kg',
                    ),
                    const Divider(height: 24),
                    _buildSettingItem(
                      icon: Icons.directions_run,
                      title: 'Activity Level',
                      subtitle: profile.activityLevel,
                    ),
                    const Divider(height: 24),
                    _buildSettingItem(
                      icon: Icons.flag,
                      title: 'Goal',
                      subtitle: profile.goal,
                    ),
                    const Divider(height: 24),
                    GestureDetector(
                      onTap: () => _showCuisinePicker(context, userProvider),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          const Icon(Icons.restaurant_rounded, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Regional Diet / Cuisine',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    GlassyBadge.flag(
                                      FoodData.cuisineFlags[profile.cuisine] ?? '🇧🇩',
                                      size: 22,
                                      fontSize: 13,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      profile.cuisine,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF8A8A96),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.lime.withValues(alpha: 0.15)
                                  : const Color(0xFFEFF8E4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  profile.cuisine,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppTheme.lime : const Color(0xFF3F7F0B),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right,
                                  size: 14,
                                  color: isDark ? AppTheme.lime : const Color(0xFF3F7F0B),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Recalculate / Update Profile',
                isGhost: true,
                onPressed: () {
                  userProvider.resetOnboarding();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 12),

              // Sign Out Button
              CustomButton(
                text: authProvider.isGuest ? 'Sign In / Register' : 'Sign Out',
                isGhost: false,
                onPressed: () async {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9A9AA6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A8A96),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCuisinePicker(BuildContext context, UserProvider userProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCuisine = userProvider.profile.cuisine;

    final cuisines = [
      {
        'name': 'Bangladeshi',
        'flag': '🇧🇩',
        'desc': 'Ruti, Bhat, Dal, Fish, Dim Bhaji, Chicken',
      },
      {
        'name': 'Indian',
        'flag': '🇮🇳',
        'desc': 'Dosa, Idli, Chapati, Paneer, Dal Tadka',
      },
      {
        'name': 'Western',
        'flag': '🇺🇸',
        'desc': 'Oatmeal, Greek Yogurt, Salmon, Salad, Eggs',
      },
      {
        'name': 'Middle Eastern',
        'flag': '🇦🇪',
        'desc': 'Shakshuka, Hummus, Shawarma, Kebab, Dates',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF191922) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Choose Regional Cuisine',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tailors your daily "EAT NEXT" recommendations and food catalogs to your local culinary habits.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 18),
                ...cuisines.map((item) {
                  final isSelected = currentCuisine == item['name'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        userProvider.setCuisine(item['name']!);
                        Navigator.of(ctx).pop();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppTheme.lime.withValues(alpha: 0.15)
                                  : const Color(0xFFF2F9E8))
                              : (isDark
                                  ? const Color(0xFF22222E)
                                  : const Color(0xFFF7F6F2)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lime
                                : (isDark
                                    ? const Color(0xFF2E2E3C)
                                    : const Color(0xFFE8E5DD)),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            GlassyBadge.flag(
                              item['flag']!,
                              size: 36,
                              fontSize: 20,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['desc']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppTheme.lime,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: AppTheme.ink,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
