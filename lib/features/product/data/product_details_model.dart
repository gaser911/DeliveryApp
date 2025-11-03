// lib/features/product/data/product_details_model.dart (New File)

class Topping {
  final String id;
  final String name;
  final String assetPath;
  final double price;

  Topping({required this.id, required this.name, required this.assetPath, this.price = 0.50});
}

// Base burger price
const double basePrice = 14.99;

// --- Mock Data: Unified List of Add-ons ---

final List<Topping> mockToppings = [
  // Original Toppings
  Topping(id: 't1', name: 'Tomato', assetPath: 'assets/images/tomato.png', price: 0),
  Topping(id: 't2', name: 'Onions', assetPath: 'assets/images/onions.png', price: 0),
  Topping(id: 't3', name: 'Pickles', assetPath: 'assets/images/pickles.png', price: 0),
  Topping(id: 't4', name: 'Bacons', assetPath: 'assets/images/bacon.png', price: 1.50),

  // Items originally from Side Options (now unified)
  Topping(id: 's1', name: 'Fries', assetPath: 'assets/images/fries.png', price: 2.99),
  Topping(id: 's2', name: 'Coleslaw', assetPath: 'assets/images/coleslaw.png', price: 2.49),
  Topping(id: 's3', name: 'Salad', assetPath: 'assets/images/salad.png', price: 3.25),
  Topping(id: 's4', name: 'Onion Rings', assetPath: 'assets/images/onionrings.png', price: 3.50),
];