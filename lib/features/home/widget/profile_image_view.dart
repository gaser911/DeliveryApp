// lib/features/home/widget/profile_image_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app/features/auth/data/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: userProvider.imagePath != null
              ? Image.file(
                  File(userProvider.imagePath!),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
        );
      },
    );
  }
}