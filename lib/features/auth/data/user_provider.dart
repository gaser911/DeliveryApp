// lib/features/auth/data/user_provider.dart
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'Guest';
  String _email = 'guest@example.com';
  String _deliveryAddress = 'No address provided';
  String _password = '';
  String? _imagePath;
  bool _isLoggedIn = false;
  
  // Payment card details
  String? _cardType;
  String? _cardNumber;
  String? _cardHolderName;
  String? _cardExpiryDate;
  String? _cardCVV;

  String get name => _name;
  String get email => _email;
  String get deliveryAddress => _deliveryAddress;
  String get password => _password;
  String? get imagePath => _imagePath;
  bool get isLoggedIn => _isLoggedIn;
  
  String? get cardType => _cardType;
  String? get cardNumber => _cardNumber;
  String? get cardHolderName => _cardHolderName;
  String? get cardExpiryDate => _cardExpiryDate;
  String? get cardCVV => _cardCVV;
  
  bool get hasCard => _cardNumber != null && _cardNumber!.isNotEmpty;

  // Update user profile - only updates fields that are provided
  void updateProfile({
    String? name,
    String? email,
    String? deliveryAddress,
    String? password,
    String? imagePath,
  }) {
    if (name != null && name.isNotEmpty) _name = name;
    if (email != null && email.isNotEmpty) _email = email;
    if (deliveryAddress != null && deliveryAddress.isNotEmpty) _deliveryAddress = deliveryAddress;
    if (password != null && password.isNotEmpty) _password = password;
    if (imagePath != null) _imagePath = imagePath;
    notifyListeners();
  }

  // Update card details
  void updateCard({
    required String cardType,
    required String cardNumber,
    required String cardHolderName,
    required String cardExpiryDate,
    required String cardCVV,
  }) {
    _cardType = cardType;
    _cardNumber = cardNumber;
    _cardHolderName = cardHolderName;
    _cardExpiryDate = cardExpiryDate;
    _cardCVV = cardCVV;
    notifyListeners();
  }

  // Remove card
  void removeCard() {
    _cardType = null;
    _cardNumber = null;
    _cardHolderName = null;
    _cardExpiryDate = null;
    _cardCVV = null;
    notifyListeners();
  }

  // Login user
  void login({
    required String name,
    required String email,
    String? deliveryAddress,
    String? password,
    String? imagePath,
  }) {
    _name = name;
    _email = email;
    _deliveryAddress = deliveryAddress ?? 'No address provided';
    _password = password ?? '';
    _imagePath = imagePath;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Signup user
  void signup({
    required String name,
    required String email,
    required String password,
    String? deliveryAddress,
    String? imagePath,
  }) {
    _name = name;
    _email = email;
    _password = password;
    _deliveryAddress = deliveryAddress ?? 'No address provided';
    _imagePath = imagePath;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Logout user
  void logout() {
    _name = 'Guest';
    _email = 'guest@example.com';
    _deliveryAddress = 'No address provided';
    _password = '';
    _imagePath = null;
    _isLoggedIn = false;
    _cardType = null;
    _cardNumber = null;
    _cardHolderName = null;
    _cardExpiryDate = null;
    _cardCVV = null;
    notifyListeners();
  }

  // Reset to guest
  void resetToGuest() {
    logout();
  }
}