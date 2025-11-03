import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
class OptionCard extends StatelessWidget {
  final String name;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTopping; 

  const OptionCard({
    super.key,
    required this.name,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
    this.isTopping = true,
  });

  @override
  Widget build(BuildContext context) {
    // Icon changes based on selection and type
    final IconData icon = isSelected
        ? Icons.remove_circle // Use minus for selected
        : Icons.add_circle;   // Use plus for unselected

    // Icon color: Red for remove, Green for add
    final Color iconColor = isSelected ? Appcolors.kPrimaryRed : Colors.green[700]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Option Image Container
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0), // Slightly larger radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08), // Darker, more pronounced shadow
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4), 
                      ),
                    ],
                    border: Border.all(
                      color: isSelected ? iconColor : Colors.grey.shade100, // Light border when unselected
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    assetPath,
                    width: 60, // Slightly larger image area
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                  ),
                ),
                // Selection Icon (positioned outside the box)
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Option Name
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
