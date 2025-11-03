// lib/features/auth/view/login_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/core/router/app_router.dart';
import 'package:food_app/features/auth/data/user_provider.dart';
import 'package:food_app/features/auth/widgets/custom_button.dart';
import 'package:food_app/shared/custom_text.dart';
import 'package:food_app/shared/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Simple login - in real app, you'd verify credentials
      userProvider.login(
        name: emailController.text.split('@')[0], // Extract name from email
        email: emailController.text,
        password: passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to checkout or home
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.home,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Appcolors.primary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Gap(50),
                    SvgPicture.asset(
                      "assets/images/Hungry.svg",
                      color: Colors.white,
                      height: 100,
                      width: 100,
                    ),
                    const Gap(10),
                    const CustomText(
                      text: "Welcome Back!",
                      color: Colors.white,
                      size: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    const Gap(10),
                    const CustomText(
                      text: "Login to continue your food journey",
                      color: Colors.white70,
                      size: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const Gap(80),
                    CustomTextField(
                      hintText: "Email Address",
                      isPassword: false,
                      controller: emailController,
                    ),
                    const Gap(25),
                    CustomTextField(
                      hintText: "Password",
                      isPassword: true,
                      controller: passwordController,
                    ),
                    const Gap(50),
                    CustomAuthButton(
                      text: "Login",
                      onTap: _handleLogin,
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, AppRouter.signup);
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}