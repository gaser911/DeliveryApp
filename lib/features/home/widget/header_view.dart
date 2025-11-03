// lib/features/home/widget/header_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/features/auth/data/user_provider.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Show "Hello" for guests, "Hello, [Name]" for logged in users
        final greeting = userProvider.isLoggedIn 
            ? "Hello, ${userProvider.name}" 
            : "Hello";
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/images/Hungry.svg",
              color: Appcolors.primary,
              height: 37,
              width: 37,
            ),
            const Gap(6),
            CustomText(
              text: greeting,
              size: 16,
              color: Colors.grey.shade900,
            ),
          ],
        );
      },
    );
  }
}