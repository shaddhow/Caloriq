import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart';
import '../utils/calculators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 1;

  // Form state (all null by default to avoid dummy/demo pre-selections)
  String? _gender;
  int? _age;
  double _height = 172.0;
  bool _heightSet = false;
  double? _weight;
  String? _activityLevel;
  String? _goal;
  String? _pace;

  // Height unit state
  String _heightUnit = 'ft'; // 'ft' (Feet & Inches) or 'm' (Meters)
  int _heightFeet = 5;
  int _heightInches = 8;
  double _heightMeters = 1.72;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _syncHeightFromCm(_height);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncHeightFromCm(double cm) {
    final totalInches = (cm / 2.54).round();
    _heightFeet = (totalInches ~/ 12).clamp(3, 7);
    _heightInches = (totalInches % 12).clamp(0, 11);
    _heightMeters =
        double.parse((cm / 100.0).toStringAsFixed(2)).clamp(1.0, 2.3);
  }

  void _updateHeightInCm() {
    if (_heightUnit == 'ft') {
      final totalInches = (_heightFeet * 12) + _heightInches;
      _height = totalInches * 2.54;
      _heightMeters =
          double.parse((_height / 100.0).toStringAsFixed(2)).clamp(1.0, 2.3);
    } else {
      _height = _heightMeters * 100.0;
      final totalInches = (_height / 2.54).round();
      _heightFeet = (totalInches ~/ 12).clamp(3, 7);
      _heightInches = (totalInches % 12).clamp(0, 11);
    }
  }

  void _onHeightUnitChanged(String newUnit) {
    setState(() {
      _heightUnit = newUnit;
      _updateHeightInCm();
    });
  }

  UserProfile get _currentProfile => UserProfile(
        gender: _gender ?? 'Male',
        age: _age ?? 25,
        height: _height,
        weight: _weight ?? 70.0,
        activityLevel: _activityLevel ?? 'Moderate',
        goal: _goal ?? 'Lose fat',
        pace: _pace ?? 'Moderate',
      );

  void _onPaceSelected(String newPace) {
    setState(() {
      _pace = newPace;
    });
    if (newPace == 'Intense' || newPace == 'Extreme') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  void _onGoalSelected(String newGoal) {
    setState(() {
      _goal = newGoal;
    });
    if (newGoal == 'Lose fat') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  void _showValidationToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextStep() {
    if (_step == 1) {
      if (_gender == null) {
        _showValidationToast('Please select your gender');
        return;
      }
      if (_age == null) {
        _showValidationToast('Please set your age');
        return;
      }
    } else if (_step == 2) {
      if (!_heightSet) {
        _showValidationToast('Please adjust and set your height');
        return;
      }
      if (_weight == null) {
        _showValidationToast('Please set your weight');
        return;
      }
    } else if (_step == 3) {
      if (_activityLevel == null) {
        _showValidationToast('Please select your activity level');
        return;
      }
      if (_goal == null) {
        _showValidationToast('Please select your primary goal');
        return;
      }
      if (_goal == 'Lose fat' && _pace == null) {
        _showValidationToast('Please select your weight loss pace');
        return;
      }
    }

    setState(() {
      _step++;
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  void _prevStep() {
    if (_step > 1) {
      setState(() {
        _step--;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    }
  }

  void _completeOnboarding() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.saveUserProfile(_currentProfile);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Progress Indicator (3 step bars)
              if (_step <= 3) ...[
                Row(
                  children: List.generate(3, (index) {
                    final isActive = _step >= (index + 1);
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 5,
                        decoration: BoxDecoration(
                          color: isActive
                              ? (isDark ? Colors.white : AppTheme.ink)
                              : (isDark
                                  ? const Color(0xFF2A2A33)
                                  : const Color(0xFFE9E6DF)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
              ],

              // Main Step Body
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: _buildStepContent(),
                ),
              ),

              // Bottom Action Buttons (Steps 1-3)
              if (_step <= 3) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_step > 1) ...[
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          text: 'Back',
                          isGhost: true,
                          onPressed: _prevStep,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: _nextStep,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
      default:
        return _buildSummaryStep();
    }
  }

  // Step 1: Gender & Age
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 1 of 3',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'About you',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 20),

        _buildOptionGroup(
          options: const ['Male', 'Female', 'Other'],
          selectedValue: _gender,
          onSelected: (val) => setState(() => _gender = val),
        ),
        const SizedBox(height: 16),

        _buildNumericPickerCard(
          label: 'Age',
          valueText: _age == null ? null : '$_age',
          placeholderText: 'Slide to enter age',
          unitText: 'yrs',
          value: (_age ?? 25).toDouble(),
          min: 14,
          max: 80,
          onChanged: (val) => setState(() => _age = val.round()),
        ),
      ],
    );
  }

  // Step 2: Height & Weight
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 2 of 3',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your body',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 20),

        _buildHeightPickerCard(),
        const SizedBox(height: 16),

        _buildNumericPickerCard(
          label: 'Weight',
          valueText: _weight == null ? null : '${_weight!.round()}',
          placeholderText: 'Slide to enter weight',
          unitText: 'kg',
          value: _weight ?? 65.0,
          min: 35,
          max: 160,
          onChanged: (val) => setState(() => _weight = val),
        ),
      ],
    );
  }

  // Step 3: Lifestyle & Goal
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 3 of 3',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Lifestyle & goal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Activity',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        _buildOptionGroup(
          options: const ['Light', 'Moderate', 'Active'],
          selectedValue: _activityLevel,
          onSelected: (val) => setState(() => _activityLevel = val),
        ),
        const SizedBox(height: 20),

        const Text(
          'Goal',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        _buildOptionGroup(
          options: const ['Lose fat', 'Maintain', 'Build muscle'],
          selectedValue: _goal,
          onSelected: _onGoalSelected,
        ),

        if (_goal == 'Lose fat') ...[
          const SizedBox(height: 16),
          _buildPaceSelectorWidget(),
          if (_pace == 'Intense' || _pace == 'Extreme') ...[
            const SizedBox(height: 12),
            _buildHealthRiskCautionCard(),
          ],
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  // Summary Step: Modern Metabolic Blueprint
  Widget _buildSummaryStep() {
    final metrics = ProfileMetrics.fromProfile(_currentProfile);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.lime,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.check, color: AppTheme.ink),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalized Blueprint',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const Text(
                  'Your plan is ready.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Pace Selector (if Goal is Lose Fat)
        if (_goal == 'Lose fat') ...[
          _buildPaceSelectorWidget(),
          const SizedBox(height: 14),
          if (_pace == 'Intense' || _pace == 'Extreme') ...[
            _buildHealthRiskCautionCard(),
            const SizedBox(height: 14),
          ],
        ],

        // 1. Energy Flow Diagram Card
        _buildEnergyFlowCard(metrics),
        const SizedBox(height: 14),

        // 2. Interactive BMI Spectrum Gauge Card
        _buildBmiGaugeCard(metrics),
        const SizedBox(height: 14),

        // 3. Macronutrient Triad Grid
        _buildMacroTriadCard(metrics),
        const SizedBox(height: 14),

        // 4. Weekly Goal Roadmap Badge
        _buildGoalRoadmapCard(metrics),
        const SizedBox(height: 24),

        // Primary Call To Action
        CustomButton(
          text: 'Open dashboard',
          onPressed: _completeOnboarding,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaceSelectorWidget() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final paces = [
      {'key': 'Mild', 'label': 'Mild', 'rate': '-1.2 kg/mo'},
      {'key': 'Moderate', 'label': 'Moderate', 'rate': '-2.0 kg/mo'},
      {'key': 'Intense', 'label': 'Intense', 'rate': '-3.0 kg/mo'},
      {'key': 'Extreme', 'label': 'Extreme', 'rate': '-4.0 kg/mo'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Loss Pace',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Text(
                'Select monthly target',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: paces.map((p) {
              final isSelected = _pace == p['key'];
              final isHighRisk =
                  p['key'] == 'Intense' || p['key'] == 'Extreme';

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onPaceSelected(p['key']!),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isHighRisk
                              ? (isDark
                                  ? const Color(0xFFC62828)
                                  : const Color(0xFFD32F2F))
                              : (isDark ? Colors.white : AppTheme.ink))
                          : (isDark
                              ? const Color(0xFF26262F)
                              : const Color(0xFFF6F5F2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          p['label']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p['rate']!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRiskCautionCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExtreme = _pace == 'Extreme';
    final accentColor = isExtreme ? AppTheme.coral : const Color(0xFFF59E0B);
    final floorCalories = (_gender ?? 'Male').toLowerCase() == 'female' ? 1200 : 1500;

    return GestureDetector(
      onTap: () => _showHealthProtocolBottomSheet(
        context: context,
        isExtreme: isExtreme,
        floorCalories: floorCalories,
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? (isExtreme ? const Color(0xFF231617) : const Color(0xFF221C14))
              : (isExtreme ? const Color(0xFFFFF4F2) : const Color(0xFFFFFBF2)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.25 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isExtreme ? Icons.bolt_rounded : Icons.health_and_safety_rounded,
                color: accentColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isExtreme ? 'Extreme Deficit Advisory' : 'Intense Pace Advisory',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppTheme.ink,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          isExtreme ? 'HIGH RISK' : 'ELEVATED',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$floorCalories kcal floor & protein guard active · Tap to review',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: isDark ? Colors.white70 : AppTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHealthProtocolBottomSheet({
    required BuildContext context,
    required bool isExtreme,
    required int floorCalories,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isExtreme ? AppTheme.coral : const Color(0xFFF59E0B);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            bottomInset > 0 ? bottomInset + 12 : 20,
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181820) : Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.16),
                blurRadius: 32,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Grab handle
              Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: isDark ? 0.22 : 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isExtreme ? Icons.bolt_rounded : Icons.health_and_safety_rounded,
                              color: accentColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'METABOLIC PROTOCOL',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.1,
                                        color: accentColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        isExtreme ? 'HIGH RISK' : 'ELEVATED',
                                        style: const TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isExtreme ? 'Extreme Deficit Protocol' : 'Intense Pace Protocol',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    color: isDark ? Colors.white : AppTheme.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: isDark ? Colors.white70 : AppTheme.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Text(
                        'Why this pace requires strict guardrails:',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : AppTheme.ink.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 3 Micro-Cards for Risks
                      _buildModernRiskItem(
                        icon: Icons.fitness_center_rounded,
                        iconColor: const Color(0xFFEF4444),
                        title: 'Muscle Mass Preservation',
                        description:
                            'Steep deficits prompt the body to catabolize lean tissue for immediate fuel without high protein intake.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildModernRiskItem(
                        icon: Icons.speed_rounded,
                        iconColor: const Color(0xFFF97316),
                        title: 'Metabolic Adaptation',
                        description:
                            'Adaptive thermogenesis lowers your BMR over time, making weight rebound (yo-yo effect) much more likely.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildModernRiskItem(
                        icon: Icons.battery_alert_rounded,
                        iconColor: const Color(0xFFEAB308),
                        title: 'Energy & Micronutrient Gaps',
                        description:
                            'Very low energy intake can trigger acute lethargy, cognitive brain fog, and micronutrient deficiencies.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),

                      // Caloriq Active Guardrails (Signature Brand Feature)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF141E13) : const Color(0xFFF3F9EA),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.lime.withValues(alpha: isDark ? 0.35 : 0.65),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.lime,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.shield_rounded,
                                    size: 14,
                                    color: AppTheme.ink,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Caloriq Safety Guardrails',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : AppTheme.ink,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lime.withValues(alpha: isDark ? 0.3 : 0.4),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                      color: isDark ? AppTheme.lime : const Color(0xFF2E5300),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildGuardrailRow(
                              title: '35% High Protein Target',
                              desc: 'Auto-boosted macro ratio to protect muscle mass during calorie restriction.',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 8),
                            _buildGuardrailRow(
                              title: '$floorCalories kcal Safety Floor',
                              desc: 'Hard intake minimum locked in to prevent severe metabolic shutdown.',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 8),
                            _buildGuardrailRow(
                              title: '2–4 Week Time Limit',
                              desc: 'Maintain this pace for max 4 weeks, then cycle to maintenance.',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Understand / Close Action
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : AppTheme.ink,
                            foregroundColor: isDark ? AppTheme.ink : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'I Understand & Accept Protocol',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernRiskItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191314) : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.3,
                    color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuardrailRow({
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.check_circle_rounded, size: 13, color: AppTheme.lime),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: isDark ? Colors.white70 : AppTheme.ink.withValues(alpha: 0.8),
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppTheme.ink,
                  ),
                ),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyFlowCard(ProfileMetrics metrics) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int offset = metrics.offset;
    String offsetText =
        offset < 0 ? '$offset kcal' : (offset > 0 ? '+$offset kcal' : '0 kcal');
    String goalExplanation = '';

    if (_goal == 'Lose fat') {
      final absOffset = offset.abs();
      goalExplanation =
          'Burning ~${metrics.tdee} kcal daily. Consuming ${metrics.budget} kcal creates a $absOffset kcal daily deficit for fat loss.';
    } else if (_goal == 'Build muscle') {
      goalExplanation =
          'Burning ~${metrics.tdee} kcal daily. Consuming ${metrics.budget} kcal provides a 250 kcal surplus to fuel muscle growth.';
    } else {
      goalExplanation =
          'Consuming ${metrics.budget} kcal daily balances your TDEE (${metrics.tdee} kcal) to maintain current weight.';
    }

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Energy Flow',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.lime.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _goal == 'Lose fat' ? '$_goal (${_pace ?? 'Moderate'})' : (_goal ?? ''),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visual Flow Row
          Row(
            children: [
              // Maintenance TDEE Block
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF26262F)
                        : const Color(0xFFF2EFEE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maintenance',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${metrics.tdee}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'kcal/day',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Flow Arrow & Offset Badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    const Icon(Icons.arrow_forward_rounded, size: 16),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: offset < 0
                            ? Colors.amber.withValues(alpha: 0.2)
                            : (offset > 0
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        offsetText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: offset < 0
                              ? Colors.orange.shade800
                              : (offset > 0
                                  ? Colors.green.shade800
                                  : Colors.grey.shade800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Daily Target Block (Highlighted in Lime)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lime,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Target',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${metrics.budget}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppTheme.ink,
                        ),
                      ),
                      const Text(
                        'kcal/day',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Math Explanation Caption
          Text(
            goalExplanation,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBmiGaugeCard(ProfileMetrics metrics) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      backgroundColor: isDark
          ? const Color(0xFF22222B)
          : AppTheme.lilac.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Body Mass Index (BMI)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.ink,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.ink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  metrics.bmiCategory,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // BMI Big Score
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${metrics.bmi}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'score',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Spectrum Gauge Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final indicatorPos = (totalWidth * metrics.bmiPosition)
                  .clamp(8.0, totalWidth - 8.0);

              return Column(
                children: [
                  // Gauge Bar with 4 segments
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 10,
                                    color: const Color(0xFF64B5F6))),
                            const SizedBox(width: 2),
                            Expanded(
                                child: Container(
                                    height: 10,
                                    color: const Color(0xFF81C784))),
                            const SizedBox(width: 2),
                            Expanded(
                                child: Container(
                                    height: 10,
                                    color: const Color(0xFFFFB74D))),
                            const SizedBox(width: 2),
                            Expanded(
                                child: Container(
                                    height: 10,
                                    color: const Color(0xFFE57373))),
                          ],
                        ),
                      ),
                      // Indicator Pointer
                      Positioned(
                        left: indicatorPos - 7,
                        top: -4,
                        child: Container(
                          width: 14,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : AppTheme.ink,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppTheme.lime,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Labels Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Underweight',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).hintColor)),
                      Text('Healthy',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).hintColor)),
                      Text('Overweight',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).hintColor)),
                      Text('Obese',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).hintColor)),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          // Health Insight Note
          Text(
            'Your daily budget of ${metrics.budget} kcal is designed to move your BMI towards the healthy range at a safe, sustainable pace.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTriadCard(ProfileMetrics metrics) {
    // If Intense/Extreme pace, boost protein to 35% for muscle protection
    final isHighRiskPace = _pace == 'Intense' || _pace == 'Extreme';
    final proteinPct = isHighRiskPace ? 0.35 : 0.30;
    final carbsPct = isHighRiskPace ? 0.35 : 0.40;
    final fatPct = 0.30;

    final proteinGrams = (metrics.budget * proteinPct / 4).round();
    final carbsGrams = (metrics.budget * carbsPct / 4).round();
    final fatGrams = (metrics.budget * fatPct / 9).round();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Macro Targets',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Text(
                isHighRiskPace ? '35/35/30 (High Protein)' : '30/40/30 Split',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Column Bento Cards
          Row(
            children: [
              _buildMacroTile('Protein', '${proteinGrams}g',
                  '${(proteinPct * 100).round()}%', AppTheme.lime),
              const SizedBox(width: 8),
              _buildMacroTile('Carbs', '${carbsGrams}g',
                  '${(carbsPct * 100).round()}%', AppTheme.lilac),
              const SizedBox(width: 8),
              _buildMacroTile('Fat', '${fatGrams}g',
                  '${(fatPct * 100).round()}%', const Color(0xFFFFD54F)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTile(
      String name, String grams, String percent, Color accentColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF26262F) : const Color(0xFFF6F5F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              grams,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              percent,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRoadmapCard(ProfileMetrics metrics) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String weeklyPace = '-0.5 kg';
    String monthlyEstimate = '~ -2.0 kg';
    String subtitle = 'Recommended, safe & sustainable pace';
    IconData icon = Icons.trending_down_rounded;

    if (_goal == 'Lose fat') {
      switch (_pace) {
        case 'Mild':
          weeklyPace = '-0.3 kg';
          monthlyEstimate = '~ -1.2 kg';
          subtitle = 'Gradual, flexible & easy pace';
          break;
        case 'Intense':
          weeklyPace = '-0.75 kg';
          monthlyEstimate = '~ -3.0 kg';
          subtitle = 'Faster fat loss pace (Higher discipline needed)';
          break;
        case 'Extreme':
          weeklyPace = '-1.0 kg';
          monthlyEstimate = '~ -4.0 kg';
          subtitle = 'Maximum safe pace (Short-term focus recommended)';
          break;
        case 'Moderate':
        default:
          weeklyPace = '-0.5 kg';
          monthlyEstimate = '~ -2.0 kg';
          subtitle = 'Recommended, safe & sustainable pace';
          break;
      }
    } else if (_goal == 'Build muscle') {
      weeklyPace = '+0.25 kg';
      monthlyEstimate = '~ +1.0 kg';
      subtitle = 'Optimal pace for clean muscle gain';
      icon = Icons.trending_up_rounded;
    } else {
      weeklyPace = '0.0 kg';
      monthlyEstimate = 'Stable weight';
      subtitle = 'Weight maintenance mode';
      icon = Icons.trending_flat_rounded;
    }

    return CustomCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A33) : AppTheme.ink,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppTheme.lime,
              size: 24,
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
                      'Pace Estimate',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      '$weeklyPace / week',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '30-Day Outlook: $monthlyEstimate',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroup({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: options.map((option) {
        final isSelected = selectedValue == option;
        final cardBg = isDark ? const Color(0xFF1A1A21) : AppTheme.card;

        return GestureDetector(
          onTap: () => onSelected(option),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? (isDark ? Colors.white : AppTheme.ink)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 20,
                    color: isDark ? Colors.white : AppTheme.ink,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumericPickerCard({
    required String label,
    required String? valueText,
    required String placeholderText,
    required String unitText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),
              if (valueText == null)
                Text(
                  placeholderText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor,
                  ),
                )
              else
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: isDark ? Colors.white : AppTheme.ink,
                    ),
                    children: [
                      TextSpan(
                        text: valueText,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      TextSpan(
                        text: ' $unitText',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: isDark ? Colors.white : AppTheme.ink,
              inactiveTrackColor: isDark
                  ? const Color(0xFF2A2A33)
                  : const Color(0xFFE9E6DF),
              thumbColor: isDark ? Colors.white : AppTheme.ink,
              overlayColor: (isDark ? Colors.white : AppTheme.ink)
                  .withValues(alpha: 0.12),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightPickerCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Label & Unit Segmented Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Height',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).hintColor,
                ),
              ),

              // Segmented toggle: Feet vs Meter
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2A33)
                      : const Color(0xFFE9E6DF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildUnitTab(
                      label: 'Feet (ft/in)',
                      isSelected: _heightUnit == 'ft',
                      onTap: () => _onHeightUnitChanged('ft'),
                    ),
                    _buildUnitTab(
                      label: 'Meter (m)',
                      isSelected: _heightUnit == 'm',
                      onTap: () => _onHeightUnitChanged('m'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Value display and Slider controls
          if (_heightUnit == 'ft') ...[
            // Feet & Inches Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _heightSet
                      ? '$_heightFeet ft $_heightInches in'
                      : 'Slide to enter height',
                  style: TextStyle(
                    fontSize: _heightSet ? 28 : 14,
                    fontWeight: _heightSet ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: _heightSet ? -0.8 : 0,
                    color: _heightSet
                        ? (isDark ? Colors.white : AppTheme.ink)
                        : Theme.of(context).hintColor,
                  ),
                ),
                if (_heightSet)
                  Text(
                    '$_heightFeet ft $_heightInches in',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Feet Slider
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(
                    'Feet',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: _sliderTheme(isDark),
                    child: Slider(
                      value: _heightFeet.toDouble(),
                      min: 3,
                      max: 7,
                      divisions: 4,
                      label: '$_heightFeet ft',
                      onChanged: (val) {
                        setState(() {
                          _heightSet = true;
                          _heightFeet = val.round();
                          _updateHeightInCm();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    '$_heightFeet ft',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            // Inches Slider
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(
                    'Inches',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: _sliderTheme(isDark),
                    child: Slider(
                      value: _heightInches.toDouble(),
                      min: 0,
                      max: 11,
                      divisions: 11,
                      label: '$_heightInches in',
                      onChanged: (val) {
                        setState(() {
                          _heightSet = true;
                          _heightInches = val.round();
                          _updateHeightInCm();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    '$_heightInches in',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Meter Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _heightSet
                      ? '${_heightMeters.toStringAsFixed(2)} m'
                      : 'Slide to enter height',
                  style: TextStyle(
                    fontSize: _heightSet ? 28 : 14,
                    fontWeight: _heightSet ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: _heightSet ? -0.8 : 0,
                    color: _heightSet
                        ? (isDark ? Colors.white : AppTheme.ink)
                        : Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Meter Slider
            SliderTheme(
              data: _sliderTheme(isDark),
              child: Slider(
                value: _heightMeters,
                min: 1.20,
                max: 2.20,
                divisions: 100,
                label: '${_heightMeters.toStringAsFixed(2)} m',
                onChanged: (val) {
                  setState(() {
                    _heightSet = true;
                    _heightMeters = double.parse(val.toStringAsFixed(2));
                    _updateHeightInCm();
                  });
                },
              ),
            ),
          ],

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),

          // Auto-set Centimeter Output Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.lime.withValues(alpha: 0.15)
                  : AppTheme.lime.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.lime,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: isDark ? Colors.white : AppTheme.ink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Centimeter (Auto set):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.ink,
                      ),
                    ),
                  ],
                ),
                Text(
                  _heightSet ? '${_height.round()} cm' : 'Adjust above to set',
                  style: TextStyle(
                    fontSize: _heightSet ? 18 : 13,
                    fontWeight: _heightSet ? FontWeight.w800 : FontWeight.w600,
                    color: _heightSet
                        ? (isDark ? Colors.white : AppTheme.ink)
                        : Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : AppTheme.ink)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? (isDark ? AppTheme.ink : Colors.white)
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }

  SliderThemeData _sliderTheme(bool isDark) {
    return SliderThemeData(
      activeTrackColor: isDark ? Colors.white : AppTheme.ink,
      inactiveTrackColor:
          isDark ? const Color(0xFF2A2A33) : const Color(0xFFE9E6DF),
      thumbColor: isDark ? Colors.white : AppTheme.ink,
      overlayColor:
          (isDark ? Colors.white : AppTheme.ink).withValues(alpha: 0.12),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    );
  }
}

