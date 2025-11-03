import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.image,
    required this.name,
    required this.desc,
    required this.rating,
  });

  final String image;
  final String name;
  final String desc;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300, // ✅ Soft clean border
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Product Image
            Image.asset(
              image,
              width: 110,
              height: 110,
              fit: BoxFit.contain,
            ),
            const Gap(12),

            // ✅ Name
            CustomText(
              text: name,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              size: 16,
            ),

            // ✅ Description
            CustomText(
              text: desc,
              size: 14,
              color: Colors.black54,
            ),

            const Gap(10),

            // ✅ Rating with star
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Appcolors.primary,
                  size: 18,
                ),
                const Gap(4),
                CustomText(
                  text: rating,
                  color: Colors.black87,
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
