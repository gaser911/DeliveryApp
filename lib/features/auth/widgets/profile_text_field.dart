// lib/features/auth/widgets/profile_text_field.dart
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/shared/custom_text.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscured;
  final IconData? suffixIcon;
  final bool isEditing;
  final String? currentValue;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isObscured = false,
    this.suffixIcon,
    this.isEditing = false,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    const Color enabledBorderColor = Colors.white;
    const Color labelBgc = Color(0xFF132F1A);

    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isEditing ? Appcolors.primary : enabledBorderColor,
                width: isEditing ? 2.0 : 1.5,
              ),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isObscured,
              readOnly: !isEditing,
              cursorColor: Appcolors.primary,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: isEditing ? 'Enter $label' : currentValue,
                hintStyle: TextStyle(
                  color: isEditing ? Colors.grey : Colors.black87,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: Appcolors.primary)
                    : null,
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: labelBgc,
              child: CustomText(
                text: label,
                color: enabledBorderColor,
                size: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}