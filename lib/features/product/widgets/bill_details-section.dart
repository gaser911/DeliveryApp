import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';

class BillDetailsSection extends StatelessWidget {
  final double basePrice;
  final double toppingsCost;
  final List<Map<String, dynamic>> selectedToppingDetails; // <-- DEFINED HERE

  // Note: selectedToppingNames is now redundant but kept for now.
  // The logic below uses selectedToppingDetails for a richer output.

  const BillDetailsSection({
    super.key,
    required this.basePrice,
    required this.toppingsCost,
    required this.selectedToppingDetails, // <-- REQUIRED IN CONSTRUCTOR
  });

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: isTotal ? Colors.black : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              // Assuming Appcolors.kPrimaryRed is a defined constant
              color: valueColor ?? (isTotal ? Appcolors.kPrimaryRed : Colors.black),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subTotal = basePrice + toppingsCost;
    const taxRate = 0.05; // 5% tax
    final taxAmount = subTotal * taxRate;
    final total = subTotal + taxAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill Details Header
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Bill Calculation Block
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildDetailRow('Base Burger', '\$${basePrice.toStringAsFixed(2)}'),
                _buildDetailRow(
                  'Selected Add-ons', 
                  '+\$${toppingsCost.toStringAsFixed(2)}', 
                  valueColor: toppingsCost > 0 ? Colors.green[700] : Colors.grey[700]
                ),
                const Divider(height: 20, thickness: 1, color: Colors.grey),
                _buildDetailRow('Subtotal', '\$${subTotal.toStringAsFixed(2)}'),
                _buildDetailRow('Tax (5%)', '\$${taxAmount.toStringAsFixed(2)}'),
                const Divider(height: 20, thickness: 1.5, color: Colors.black),
                _buildDetailRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // Add-on Details List
          const Text(
            'Your Customizations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // CORRECTED: Use selectedToppingDetails to display name and price together
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: selectedToppingDetails.isEmpty
                ? [
                    Text('No extra add-ons selected.', style: TextStyle(color: Colors.grey[600]))
                  ]
                : selectedToppingDetails
                    .map(
                      (item) => Chip(
                        label: Text(
                          '${item['name']} (+\$${(item['price'] as double).toStringAsFixed(2)})',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF1E4620), fontWeight: FontWeight.w500),
                        ),
                        backgroundColor: Colors.blueGrey[50], // Premium background
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
