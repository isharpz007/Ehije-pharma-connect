import 'package:flutter/material.dart';

import 'cart_model.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum _DeliveryOption { standard, express }

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  _DeliveryOption _selectedDelivery = _DeliveryOption.standard;
  final _couponController = TextEditingController();

  double get _deliveryFee =>
      _selectedDelivery == _DeliveryOption.standard ? 2.50 : 5.00;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartModel.instance;
    final subtotal = cart.subtotal;
    final total = subtotal + _deliveryFee;

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
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
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
                                  'Checkout',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: darkNavy,
                                  ),
                                ),
                              ],
                            ),
                            const _SecureBadge(),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // Delivery address
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: darkNavy,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFBFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderGrey),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mrs. Amelia Clarke',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: darkNavy,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '14 Rosewood Ave, NW1',
                                style: TextStyle(fontSize: 13, color: hintGrey),
                              ),
                              Text(
                                'London, United Kingdom',
                                style: TextStyle(fontSize: 13, color: hintGrey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Delivery options
                        const Text(
                          'Delivery Options',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _DeliveryOptionTile(
                          title: 'Standard Delivery (2-3 days)',
                          price: '£2.50',
                          selected: _selectedDelivery == _DeliveryOption.standard,
                          onTap: () => setState(() => _selectedDelivery = _DeliveryOption.standard),
                        ),
                        const SizedBox(height: 10),
                        _DeliveryOptionTile(
                          title: 'Express Delivery (24 hours)',
                          price: '£5.00',
                          selected: _selectedDelivery == _DeliveryOption.express,
                          onTap: () => setState(() => _selectedDelivery = _DeliveryOption.express),
                        ),
                        const SizedBox(height: 24),

                        // Coupon
                        const Text(
                          'Apply Coupon',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                decoration: InputDecoration(
                                  hintText: 'Enter coupon code',
                                  hintStyle: const TextStyle(fontSize: 13, color: hintGrey),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderGrey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderGrey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: primaryBlue, width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coupon code is not valid'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryBlue,
                                side: const BorderSide(color: primaryBlue),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Apply',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Summary
                        _SummaryRow(label: 'Subtotal', value: '£${subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _SummaryRow(label: 'Delivery Fee', value: '£${_deliveryFee.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        const Divider(color: borderGrey),
                        const SizedBox(height: 12),
                        _SummaryRow(
                          label: 'Total',
                          value: '£${total.toStringAsFixed(2)}',
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue to Payment
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderGrey)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: cart.items.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(total: total),
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
                        'Continue to Payment',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecureBadge extends StatelessWidget {
  const _SecureBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.lock_outline, size: 14, color: Color(0xFF9B9FB1)),
        SizedBox(width: 4),
        Text(
          'Secure',
          style: TextStyle(fontSize: 12, color: Color(0xFF9B9FB1), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DeliveryOptionTile extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _DeliveryOptionTile({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F2FE) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? primaryBlue : borderGrey),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? primaryBlue : hintGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkNavy,
                ),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: hintGrey,
              ),
            ),
          ],
        ),
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
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            color: darkNavy,
          ),
        ),
      ],
    );
  }
}