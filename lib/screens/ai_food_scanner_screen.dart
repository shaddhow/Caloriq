import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/scanned_meal_result.dart';
import '../providers/meal_provider.dart';
import '../providers/user_profile_provider.dart';
import '../services/ai_food_scanner_service.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_button.dart';

class AiFoodScannerScreen extends StatefulWidget {
  final String? targetMealType;

  const AiFoodScannerScreen({super.key, this.targetMealType});

  @override
  State<AiFoodScannerScreen> createState() => _AiFoodScannerScreenState();
}

class _AiFoodScannerScreenState extends State<AiFoodScannerScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  ScannedMealResult? _scanResult;
  String _selectedMealType = 'Lunch';

  late AnimationController _scannerAnimController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.targetMealType ?? _inferMealType();

    _scannerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scannerAnimation = CurvedAnimation(
      parent: _scannerAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scannerAnimController.dispose();
    super.dispose();
  }

  String _inferMealType() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Breakfast';
    if (hour < 16) return 'Lunch';
    if (hour < 19) return 'Snacks';
    return 'Dinner';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (!mounted) return;

      setState(() {
        _imageBytes = bytes;
        _isAnalyzing = true;
        _scanResult = null;
      });

      _scannerAnimController.repeat(reverse: true);

      final userProvider =
          Provider.of<UserProfileProvider>(context, listen: false);

      final result = await AiFoodScannerService.analyzeMealImage(
        imageBytes: bytes,
        cuisine: userProvider.cuisine,
      );

      if (mounted) {
        setState(() {
          _scanResult = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture or analyze image: $e'),
            backgroundColor: AppTheme.coral,
          ),
        );
      }
    }
  }

  void _logMeal() {
    if (_scanResult == null) return;

    final mealProvider = Provider.of<MealProvider>(context, listen: false);

    for (final item in _scanResult!.items) {
      mealProvider.addLoggedItem(
        item.copyWith(mealType: _selectedMealType),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Logged ${_scanResult!.items.length} items (${_scanResult!.totalKcal} kcal) to $_selectedMealType!',
        ),
        backgroundColor: AppTheme.ink,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  void _showApiKeyDialog() async {
    final currentKey = await AiFoodScannerService.getSavedApiKey() ?? '';
    final controller = TextEditingController(text: currentKey);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E28) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Gemini API Key',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your Gemini API key to enable live online image vision. Leave blank to use Caloriq\'s built-in intelligent engine.',
                style: TextStyle(fontSize: 13, color: Theme.of(ctx).hintColor),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'AIzaSy...',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF14141B) : const Color(0xFFF5F4EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lime,
                foregroundColor: AppTheme.ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                await AiFoodScannerService.saveApiKey(controller.text);
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Save Key', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Action Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),

                  // Cuisine Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, color: AppTheme.lime, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${userProvider.cuisine} Vision',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings / API Key Button
                  GestureDetector(
                    onTap: _showApiKeyDialog,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Main Viewport / Camera Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildCameraViewport(isDark),
              ),
            ),

            // Bottom Results or Capture Actions
            if (_scanResult != null && !_isAnalyzing)
              _buildResultPanel(context, isDark)
            else
              _buildCaptureControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraViewport(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF15151C),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _isAnalyzing
              ? AppTheme.lime
              : Colors.white.withValues(alpha: 0.15),
          width: _isAnalyzing ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Captured Image or Placeholder
          if (_imageBytes != null)
            Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.center_focus_strong_rounded,
                    color: AppTheme.lime,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Point camera at your plate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'AI will analyze calories, portion & volume swaps',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),

          // Viewfinder Neon Corners
          Padding(
            padding: const EdgeInsets.all(24),
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _ViewfinderPainter(
                color: _isAnalyzing ? AppTheme.lime : Colors.white70,
              ),
            ),
          ),

          // Laser Scanning Beam Animation
          if (_isAnalyzing)
            AnimatedBuilder(
              animation: _scannerAnimation,
              builder: (context, _) {
                return Positioned(
                  top: 24 +
                      (MediaQuery.of(context).size.height *
                          0.45 *
                          _scannerAnimation.value),
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppTheme.lime,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lime.withValues(alpha: 0.8),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.lime.withValues(alpha: 0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Analyzing Loading Chip
          if (_isAnalyzing)
            Positioned(
              bottom: 24,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppTheme.lime.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.lime),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'AI Vision: Analyzing foods & volume ratios...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery Picker
          GestureDetector(
            onTap: () => _pickImage(ImageSource.gallery),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_library_outlined,
                  color: Colors.white, size: 24),
            ),
          ),

          // Camera Shutter Button
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: Container(
              width: 76,
              height: 76,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.lime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppTheme.ink, size: 32),
              ),
            ),
          ),

          // Retake / Reset
          GestureDetector(
            onTap: () {
              setState(() {
                _imageBytes = null;
                _scanResult = null;
                _isAnalyzing = false;
              });
            },
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh_rounded,
                  color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPanel(BuildContext context, bool isDark) {
    final result = _scanResult!;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.44,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF181822),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Detected Meal Name & Confidence
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.mealName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.lime.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(result.confidence * 100).round()}% Match',
                              style: const TextStyle(
                                color: AppTheme.lime,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Estimated ${result.items.length} items',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Total Calories Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.lime,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${result.totalKcal}',
                        style: const TextStyle(
                          color: AppTheme.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        'KCAL',
                        style: TextStyle(
                          color: AppTheme.ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Macro Telemetry Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF22222E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacroTile(
                    'CARBS',
                    '${result.totalCarbs.round()}g',
                    const Color(0xFFF5A623),
                  ),
                  _buildMacroTile(
                    'PROTEIN',
                    '${result.totalProtein.round()}g',
                    AppTheme.lime,
                  ),
                  _buildMacroTile(
                    'FAT',
                    '${result.totalFat.round()}g',
                    const Color(0xFF2AC4B3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Individual Detected Items Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.items.map((item) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242432),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${item.name} · ${item.kcal} kcal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // ⚠️ WHAT TO OMIT / REDUCE CARD
            if (result.omitAdvice.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.coral.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.coral.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.remove_circle_outline,
                            color: AppTheme.coral, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'WHAT TO OMIT OR REDUCE',
                          style: TextStyle(
                            color: AppTheme.coral,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        if (result.omitSavingsKcal > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.coral,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${result.omitSavingsKcal} kcal save',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.omitAdvice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),

            // 🔄 SMART HIGH-VOLUME SWAP CARD
            if (result.volumeSwapAdvice.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.lime.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.lime.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.swap_horizontal_circle_outlined,
                            color: AppTheme.lime, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '💡 VOLUME HACK · EAT MORE, WEIGH LESS',
                          style: TextStyle(
                            color: AppTheme.lime,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.volumeSwapAdvice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),

            // One-Tap Log Meal CTA Button
            CustomButton(
              text: 'Log this meal ($_selectedMealType)',
              onPressed: _logMeal,
            ),
            const SizedBox(height: 10),

            // Retake Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _scanResult = null;
                  });
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.refresh, color: Colors.white60, size: 16),
                label: const Text(
                  'Retake photo',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Custom Viewfinder Neon Corner Painter
class _ViewfinderPainter extends CustomPainter {
  final Color color;

  _ViewfinderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cornerLength = 28.0;

    // Top Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderPainter oldDelegate) =>
      oldDelegate.color != color;
}
