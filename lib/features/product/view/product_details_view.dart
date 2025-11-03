// lib/features/product/view/product_details_view.dart
import 'package:flutter/material.dart';
import 'package:food_app/core/router/app_router.dart';
import 'package:food_app/features/cart/data/cart_item_model.dart';
import 'package:food_app/features/cart/data/cart_provider.dart';
import 'package:food_app/features/product/data/product_details_model.dart';
import 'package:food_app/features/product/widgets/Customize_text.dart';
import 'package:food_app/features/product/widgets/bill_details-section.dart';
import 'package:food_app/features/product/widgets/option_card.dart';
import 'package:food_app/features/product/widgets/spicy_slider.dart';
import 'package:provider/provider.dart';

class ProductDetailsView extends StatefulWidget {
  final String productName;
  final String productImage;
  final String productType;
  final String productRating;

  const ProductDetailsView({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productType,
    required this.productRating,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double _spicyLevel = 0.5;
  final Set<String> _selectedToppingIds = {};
  bool _isSaved = false;

  Map<String, dynamic> _calculateCostAndNames() {
    double toppingsCost = 0.0;
    List<Map<String, dynamic>> selectedItemsWithPrice = [];

    for (String id in _selectedToppingIds) {
      final item = mockToppings.firstWhere(
        (t) => t.id == id,
        orElse: () => Topping(id: id, name: 'Unknown', assetPath: '', price: 0.0),
      );
      toppingsCost += item.price;
      selectedItemsWithPrice.add({
        'name': item.name,
        'price': item.price,
      });
    }

    final subTotal = basePrice + toppingsCost;
    const taxRate = 0.05;
    final total = subTotal + (subTotal * taxRate);

    return {
      'toppingsCost': toppingsCost,
      'selectedItemsWithPrice': selectedItemsWithPrice,
      'totalPrice': total,
      'basePrice': basePrice,
    };
  }

  void _addToCart(double totalPrice) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final List<String> sortedToppings = _selectedToppingIds.toList()..sort();
    final String customizationId =
        '${widget.productName.toLowerCase()}_sp${_spicyLevel.toStringAsFixed(2)}_t${sortedToppings.join("_")}_${DateTime.now().millisecondsSinceEpoch}';

    final newItem = CartItem(
      id: customizationId,
      name: widget.productName,
      type: widget.productType,
      imageAsset: widget.productImage,
      unitPrice: totalPrice,
      quantity: 1,
    );

    cartProvider.addItem(newItem);

    setState(() {
      _isSaved = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isSaved = false;
        });
        
        // Navigate to checkout
        Navigator.pushNamed(context, AppRouter.checkout);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to cart!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildToppingsSection({
    required String title,
    required List<Topping> options,
    required Set<String> selectedIds,
    required Function(String) onOptionTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return OptionCard(
                name: option.name,
                assetPath: option.assetPath,
                isSelected: selectedIds.contains(option.id),
                onTap: () => onOptionTap(option.id),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final costDetails = _calculateCostAndNames();
    final double totalPrice = costDetails['totalPrice'];
    final double toppingsCost = costDetails['toppingsCost'];
    final List<Map<String, dynamic>> selectedItemsWithPrice =
        costDetails['selectedItemsWithPrice'];
    final double currentBasePrice = costDetails['basePrice'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.productImage,
                    width: 150,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(child: Icon(Icons.fastfood, size: 60)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomizeText(),
                          SpicySlider(
                            spicyLevel: _spicyLevel,
                            onChanged: (double newValue) {
                              setState(() {
                                _spicyLevel = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            _buildToppingsSection(
              title: 'Add-ons (Toppings & Sides)',
              options: mockToppings,
              selectedIds: _selectedToppingIds,
              onOptionTap: (id) {
                setState(() {
                  if (_selectedToppingIds.contains(id)) {
                    _selectedToppingIds.remove(id);
                  } else {
                    _selectedToppingIds.add(id);
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            BillDetailsSection(
              basePrice: currentBasePrice,
              toppingsCost: toppingsCost,
              selectedToppingDetails: selectedItemsWithPrice,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 50,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: ElevatedButton(
                    key: ValueKey<bool>(_isSaved),
                    onPressed: _isSaved ? null : () => _addToCart(totalPrice),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSaved
                          ? Colors.green.shade700
                          : const Color(0xFF1E4620),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                    ),
                    child: _isSaved
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Added!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Add To Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}