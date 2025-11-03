class CartItem {
  final String id;
  final String name;
  final String type; // e.g., "Veggie Burger"
  final String imageAsset;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.type,
    required this.imageAsset,
    required this.unitPrice,
    this.quantity = 1,
  });

  // Method to copy the item details but allow changing quantity
  CartItem copyWith({
    String? id,
    String? name,
    String? type,
    String? imageAsset,
    double? unitPrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      imageAsset: imageAsset ?? this.imageAsset,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}