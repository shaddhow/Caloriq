import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/caloriq_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
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
}
