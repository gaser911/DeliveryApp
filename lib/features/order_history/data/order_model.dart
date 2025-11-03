// lib/features/order_history/data/order_model.dart
class Order {
  final String id;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status; // 'pending', 'preparing', 'delivered'
  final String deliveryAddress;

  Order({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.deliveryAddress,
  });
}

class OrderItem {
  final String name;
  final String type;
  final String imageAsset;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.type,
    required this.imageAsset,
    required this.quantity,
    required this.price,
  });
}