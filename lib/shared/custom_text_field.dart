// lib/shared/custom_text_field.dart (Standard Input Widget)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false, // Changed to non-required with default false
    this.readOnly = false, // NEW: Added read-only flag
  });

  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final bool readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }
  
  // 🔹 Static variable to temporarily store password text for comparison
  static String? passwordText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Appcolors.primary,
      cursorHeight: 19,
      readOnly: widget.readOnly, // Apply read-only status
      validator: (v) {
        if (v == null || v.isEmpty) {
          return "Please enter ${widget.hintText}";
        }

        final text = v.trim();
        final lowerHint = widget.hintText.toLowerCase();

        // 🔹 Name validation
        if (lowerHint.contains("name")) {
          if (text.length < 3) {
            return "Name must be at least 3 characters long";
          }
          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(text)) {
            return "Name can only contain letters";
          }
        }

        // 🔹 Email validation
        if (lowerHint.contains("email")) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(text)) {
            return "Please enter a valid email address";
          }
        }

        // 🔹 Password validation
        if (lowerHint == "password" || lowerHint.contains("password")) {
          if (text.length < 8) {
            return "Password must be at least 8 characters";
          }
          if (!RegExp(r'[A-Z]').hasMatch(text)) {
            return "Password must contain at least one uppercase letter";
          }
          if (!RegExp(r'[0-9]').hasMatch(text)) {
            return "Password must contain at least one number";
          }
        }

        // 🔹 Confirm password validation (compare with Password)
        if (lowerHint.contains("confirm")) {
          if (_CustomTextFieldState.passwordText != null &&
              text != _CustomTextFieldState.passwordText) {
            return "Passwords do not match";
          }
        }

        return null;
      },
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: (value) {
        // 🔹 Save password text globally for confirm password comparison
        if (widget.hintText.toLowerCase().contains("password") && !widget.hintText.toLowerCase().contains("confirm")) {
          _CustomTextFieldState.passwordText = value;
        }
      },
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText
                      ? CupertinoIcons.eye_solid
                      : CupertinoIcons.eye_slash_fill,
                  color: Appcolors.primary, // Icon color
                ),
              )
            : null,
        hintStyle: const TextStyle(
          color: Appcolors.primary,
          fontSize: 17,
          fontWeight: FontWeight.w500, // Slightly less bold font for hint
        ),
        hintText: widget.hintText,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Appcolors.primary, // Focused border color
          ),
        ),
      ),
    );
  }
}