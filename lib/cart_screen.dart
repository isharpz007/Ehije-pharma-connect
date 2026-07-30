import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'cart_model.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  @override
  Widget build(BuildContext context) {
    final cart = CartModel.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: cart,
              builder: (context, _) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.maybePop(context),
                                      borderRadius: BorderRadius.circular(20),
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.arrow_back, color: darkNavy, size: 20),
                                      ),
                                    ),
                                    const Text(
                                      'My Cart',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: darkNavy,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${cart.itemCount} items',
                                  style: const TextStyle(fontSize: 13, color: hintGrey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Empty state
                            if (cart.items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                child: Center(
                                  child: Text(
                                    'Your cart is empty',
                                    style: TextStyle(fontSize: 14, color: hintGrey),
                                  ),
                                ),
                              ),

                            // Cart items
                            for (final item in cart.items) ...[
                              _CartItemTile(
                                item: item,
                                onIncrement: () => cart.increment(item),
                                onDecrement: () => cart.decrement(item),
                                onRemove: () => cart.removeItem(item),
                              ),
                              const SizedBox(height: 14),
                            ],

                            if (cart.items.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              const Divider(color: borderGrey),
                              const SizedBox(height: 12),

                              // Subtotal
                              _SummaryRow(
                                label: 'Subtotal',
                                value: '£${cart.subtotal.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 8),
                              _SummaryRow(
                                label: 'Delivery Fee',
                                value: '£${CartModel.deliveryFee.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: borderGrey),
                              const SizedBox(height: 12),
                              _SummaryRow(
                                label: 'Total',
                                value: '£${cart.total.toStringAsFixed(2)}',
                                bold: true,
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Checkout button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: cart.items.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const CheckoutScreen(),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: const Color(0xFFC7CBD6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Proceed to Checkout',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const AppBottomNav(current: null),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderGrey),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkNavy,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Icon(Icons.delete_outline, size: 18, color: Color(0xFFE0473F)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.pharmacy,
                  style: const TextStyle(fontSize: 12, color: hintGrey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: darkNavy,
                      ),
                    ),
                    _QuantityStepper(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color borderGrey = Color(0xFFE1E3EC);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onDecrement,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.remove, size: 14, color: darkNavy),
            ),
          ),
          SizedBox(
            width: 22,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: darkNavy,
              ),
            ),
          ),
          InkWell(
            onTap: onIncrement,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add, size: 14, color: darkNavy),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({required this.label, required this.value, this.bold = false});

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            color: bold ? darkNavy : hintGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w700,
            color: darkNavy,
          ),
        ),
      ],
    );
  }
}