import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/shared/custom_text.dart';

class CustomAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomAuthButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.white,
                        ),
                        child:  Center(
                            child: CustomText(
                                text: text,
                                color: Appcolors.primary,
                                size: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
  }
}