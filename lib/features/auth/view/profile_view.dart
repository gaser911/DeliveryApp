// lib/features/auth/view/profile_view.dart
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';
import 'package:food_app/core/router/app_router.dart';
import 'package:food_app/features/auth/data/user_provider.dart';
import 'package:food_app/features/auth/widgets/add_card_dialog.dart';
import 'package:food_app/features/auth/widgets/payment_card_widget.dart';
import 'package:food_app/features/auth/widgets/profile_text_field.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  final VoidCallback? onNavigateHome;
  const ProfileView({super.key, this.onNavigateHome});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleEditState() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (!_isEditing) {
      _saveChanges();
    }
  }

  void _saveChanges() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Only update fields that have been changed (non-empty controllers)
    userProvider.updateProfile(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      email: _emailController.text.isNotEmpty ? _emailController.text : null,
      deliveryAddress: _addressController.text.isNotEmpty ? _addressController.text : null,
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
    );

    _nameController.clear();
    _emailController.clear();
    _addressController.clear();
    _passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved successfully!'),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (image != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateProfile(imagePath: image.path);
    }
  }

  void _showAddCardDialog(UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCardDialog(
          initialCardType: userProvider.cardType,
          initialCardNumber: userProvider.cardNumber,
          initialCardHolderName: userProvider.cardHolderName,
          initialExpiryDate: userProvider.cardExpiryDate,
          initialCVV: userProvider.cardCVV,
          onSave: (cardType, cardNumber, cardHolderName, expiryDate, cvv) {
            userProvider.updateCard(
              cardType: cardType,
              cardNumber: cardNumber,
              cardHolderName: cardHolderName,
              cardExpiryDate: expiryDate,
              cardCVV: cvv,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Card saved successfully!')),
            );
          },
        );
      },
    );
  }

  void _confirmRemoveCard(UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Card'),
          content: const Text('Are you sure you want to remove this card?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                userProvider.removeCard();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card removed successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Remove', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBackgroundColor = Color(0xFF132F1A);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          backgroundColor: darkBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => widget.onNavigateHome?.call(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // Profile Image
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: userProvider.imagePath != null
                            ? Image.file(
                                File(userProvider.imagePath!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Appcolors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Show login/signup buttons if not logged in
                if (!userProvider.isLoggedIn) ...[
                  const Text(
                    'Guest User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Login or Sign up to save your profile',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Appcolors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.signup);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Profile fields for logged in users
                  ProfileTextField(
                    label: 'Name',
                    controller: _nameController,
                    isEditing: _isEditing,
                    currentValue: userProvider.name,
                  ),
                  ProfileTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    isEditing: _isEditing,
                    currentValue: userProvider.email,
                  ),
                  ProfileTextField(
                    label: 'Delivery Address',
                    controller: _addressController,
                    isEditing: _isEditing,
                    currentValue: userProvider.deliveryAddress,
                  ),
                  ProfileTextField(
                    label: 'Password',
                    controller: _passwordController,
                    isObscured: true,
                    suffixIcon: Icons.lock,
                    isEditing: _isEditing,
                    currentValue: '•••••••••',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  
                  // Payment Card Section
                  if (userProvider.hasCard)
                    PaymentCardWidget(
                      cardType: userProvider.cardType!,
                      cardNumber: userProvider.cardNumber!,
                      onEdit: () => _showAddCardDialog(userProvider),
                      onRemove: () => _confirmRemoveCard(userProvider),
                    )
                  else
                    GestureDetector(
                      onTap: () => _showAddCardDialog(userProvider),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_card, color: Colors.white, size: 30),
                            SizedBox(width: 10),
                            Text(
                              'Add Payment Card',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _toggleEditState,
                          icon: Icon(
                            _isEditing ? Icons.check : Icons.edit_outlined,
                            color: _isEditing ? Colors.white : Appcolors.primary,
                          ),
                          label: Text(
                            _isEditing ? 'Save Changes' : 'Edit Profile',
                            style: TextStyle(
                              color: _isEditing ? Colors.white : Appcolors.primary,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isEditing ? Appcolors.primary : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            userProvider.logout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged out successfully')),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Log out',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Appcolors.primary,
                            side: const BorderSide(color: Appcolors.primary, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}