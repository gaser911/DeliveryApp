import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';

class SpicySlider extends StatelessWidget {
  final double spicyLevel;
  final ValueChanged<double> onChanged;

  const SpicySlider({
    super.key,
    required this.spicyLevel,
    required this.onChanged,
  });

  // Helper function to convert the slider value (0.0 - 1.0) into a descriptive string
  String _getSpicyLevelText(double level) {
    if (level == 0.0) return 'Original';
    if (level == 0.5) return 'Spicy';
    return 'Extreme';
  }

  @override
  Widget build(BuildContext context) {
    const Color sliderActiveColor = Appcolors.kPrimaryRed;
    
    // Hot icon asset
    final Widget hotIcon = Image.asset(
      'assets/images/chili_pepper.png', 
      width: 24, 
      height: 24, 
      errorBuilder: (context, error, stackTrace) => const Text('🌶️', style: TextStyle(fontSize: 24))
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spicy',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Removed mildIcon (SizedBox) as it's no longer needed at the start
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.0,
                  activeTrackColor: sliderActiveColor,
                  inactiveTrackColor: sliderActiveColor.withOpacity(0.3),
                  thumbColor: sliderActiveColor,
                  overlayColor: sliderActiveColor.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                ),
                child: Slider(
                  value: spicyLevel,
                  min: 0.0,
                  max: 1.0,
                  divisions: 2, // 3 distinct levels
                  label: _getSpicyLevelText(spicyLevel),
                  onChanged: onChanged,
                ),
              ),
            ),
            hotIcon,
          ],
        ),
        Center(
          child: Text(
            _getSpicyLevelText(spicyLevel), // <-- REMOVED THE INDEX HERE
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: sliderActiveColor,
            ),
          ),
        ),
      ],
    );
  }
}