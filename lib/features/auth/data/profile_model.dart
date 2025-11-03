// lib/features/auth/data/profile_model.dart

class UserProfile {
  final String name;
  final String email;
  final String deliveryAddress;
  final String paymentType;
  final String lastFourDigits;
  final String imageAsset;

  UserProfile({
    required this.name,
    required this.email,
    required this.deliveryAddress,
    required this.paymentType,
    required this.lastFourDigits,
    required this.imageAsset,
  });

  // Mock data for the profile page
  static final mockUser = UserProfile(
    name: 'Knuckles',
    email: 'Knuckles@gmail.com',
    deliveryAddress: '55 Dubai, UAE',
    paymentType: 'VISA',
    lastFourDigits: '0505',
    imageAsset: 'assets/images/knuckles.png', // Assuming you have this asset
  );
}