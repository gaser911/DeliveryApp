// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:food_app/features/auth/view/login_view.dart';
import 'package:food_app/features/auth/view/signup_view.dart';
import 'package:food_app/features/checkout/view/checkout_view.dart';
import 'package:food_app/features/product/view/product_details_view.dart';
import 'package:food_app/root.dart';
import 'package:food_app/spalsh.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String productDetails = '/product-details';
  static const String checkout = '/checkout';
  static const String login = '/login';
  static const String signup = '/signup';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case home:
        return MaterialPageRoute(builder: (_) => const RootView());
      case productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsView(
            productName: args?['name'] ?? 'Cheeseburger',
            productImage: args?['image'] ?? 'assets/images/item1.png',
            productType: args?['type'] ?? 'Wendy\'s Burger',
            productRating: args?['rating'] ?? '4.5',
          ),
        );
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutView());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}