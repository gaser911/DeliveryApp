// lib/features/auth/view/signup_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/core/router/app_router.dart';
import 'package:food_app/features/auth/data/user_provider.dart';
import 'package:food_app/features/auth/widgets/custom_button.dart';
import 'package:food_app/shared/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      userProvider.signup(
        name: nameController.text,
        email: emailController.text,
        password: passController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home
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
                key: _formKey,
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
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    const Text(
                      "Sign up to get started",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(60),
                    CustomTextField(
                      hintText: "Name",
                      isPassword: false,
                      controller: nameController,
                    ),
                    const Gap(13),
                    CustomTextField(
                      hintText: "Email Address",
                      isPassword: false,
                      controller: emailController,
                    ),
                    const Gap(13),
                    CustomTextField(
                      hintText: "Password",
                      isPassword: true,
                      controller: passController,
                    ),
                    const Gap(13),
                    CustomTextField(
                      hintText: "Confirm Password",
                      isPassword: true,
                      controller: confirmPassController,
                    ),
                    const Gap(50),
                    CustomAuthButton(
                      text: "Sign Up",
                      onTap: _handleSignup,
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, AppRouter.login);
                          },
                          child: const Text(
                            "Login",
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