// lib/features/checkout/view/checkout_view.dart
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/core/router/app_router.dart';
import 'package:food_app/features/auth/data/user_provider.dart';
import 'package:food_app/features/cart/data/cart_provider.dart';
import 'package:food_app/features/checkout/widgets/order_item_card.dart';
import 'package:food_app/features/checkout/widgets/order_summary_card.dart';
import 'package:food_app/features/order_history/data/order_model.dart';
import 'package:food_app/features/order_history/data/order_provider.dart';
import 'package:provider/provider.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  // UPDATED: Helper function to show missing mandatory info dialog
  void _showMandatoryInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // FIX: Navigate to the home/root page (which contains the bottom navigation bar)
                // and clear all routes beneath it, effectively taking the user to the main screen.
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.home,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Appcolors.primary),
              child: const Text('Go to Profile', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  void _proceedToPayment(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      // Existing logic for Unauthorized (Login/Signup)
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Authentication Required'),
            content: const Text(
              'Please login or signup to complete your order.',
              style: TextStyle(fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.pushNamed(context, AppRouter.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                ),
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.pushNamed(context, AppRouter.signup);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                ),
                child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    } else if (userProvider.deliveryAddress == 'No address provided' || userProvider.deliveryAddress.isEmpty) {
      // Check for Delivery Address
      _showMandatoryInfoDialog(
        context, 
        'Delivery Address Required', 
        'To proceed with your order, please update your delivery address in your profile settings.'
      );
    } else if (!userProvider.hasCard) {
      // Check for Payment Card
      _showMandatoryInfoDialog(
        context, 
        'Payment Method Required', 
        'To proceed with your order, please add a payment card in your profile settings.'
      );
    } else {
      // All mandatory information is present, proceed with order
      _placeOrder(context);
    }
  }

  void _placeOrder(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    // Create order items from cart
    final orderItems = cartProvider.items.map((cartItem) {
      return OrderItem(
        name: cartItem.name,
        type: cartItem.type,
        imageAsset: cartItem.imageAsset,
        quantity: cartItem.quantity,
        price: cartItem.unitPrice * cartItem.quantity,
      );
    }).toList();
    
    // Calculate order details
    final subtotal = cartProvider.total;
    const deliveryFee = 5.0;
    final tax = subtotal * 0.05;
    final total = subtotal + deliveryFee + tax;
    
    // Create new order
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderDate: DateTime.now(),
      items: orderItems,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: 'pending',
      deliveryAddress: userProvider.deliveryAddress,
    );
    
    // Add order to history
    orderProvider.addOrder(newOrder);
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Order Placed!'),
            ],
          ),
          content: const Text(
            'Your order has been placed successfully. We\'ll deliver it soon!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.of(dialogContext).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.home,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Helper function to build the address section with a visual cue for missing info
  Widget _buildDeliveryAddressSection(UserProvider userProvider) {
    final isAddressMissing = userProvider.deliveryAddress == 'No address provided' || userProvider.deliveryAddress.isEmpty;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: isAddressMissing ? Appcolors.kPrimaryRed : Appcolors.primary),
              const SizedBox(width: 10),
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isAddressMissing ? Appcolors.kPrimaryRed : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isAddressMissing ? 'Address is missing. Please update in profile.' : userProvider.deliveryAddress,
            style: TextStyle(
              fontSize: 16, 
              color: isAddressMissing ? Appcolors.kPrimaryRed.withOpacity(0.8) : Colors.black87,
              fontStyle: isAddressMissing ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer2<CartProvider, UserProvider>(
        builder: (context, cartProvider, userProvider, child) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  const Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.home,
                      (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Information
                  _buildDeliveryAddressSection(userProvider),
                  const SizedBox(height: 20),

                  // Order Items
                  const Text(
                    'Your Order',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ...cartProvider.items.map((item) => OrderItemCard(item: item)),
                  
                  const SizedBox(height: 20),

                  // Order Summary
                  OrderSummaryCard(
                    subtotal: cartProvider.total,
                    deliveryFee: 5.0,
                    tax: cartProvider.total * 0.05,
                  ),

                  const SizedBox(height: 30),

                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => _proceedToPayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}