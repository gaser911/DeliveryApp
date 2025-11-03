// lib/features/auth/widgets/payment_card_widget.dart
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app.colors.dart';

class PaymentCardWidget extends StatelessWidget {
  final String cardType;
  final String cardNumber;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const PaymentCardWidget({
    super.key,
    required this.cardType,
    required this.cardNumber,
    this.onEdit,
    this.onRemove,
  });

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $lastFour';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Card Type Icon
                Text(
                  cardType,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF1A1F71),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Debit card',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _maskCardNumber(cardNumber),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: Appcolors.primary, size: 20),
                  onPressed: onEdit,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              if (onRemove != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: onRemove,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
            ],
          ),
        ],
      ),
    );
  }
}