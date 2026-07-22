import 'package:flutter/material.dart';

import 'cart_model.dart';
import 'home_screen.dart';

enum _PaymentMethod { card, applePay, payPal }

class PaymentScreen extends StatefulWidget {
  final double total;
  const PaymentScreen({super.key, required this.total});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  _PaymentMethod _selectedMethod = _PaymentMethod.card;
  bool _isProcessing = false;

  Future<void> _handlePay() async {
    setState(() => _isProcessing = true);

    // Simulate a brief processing delay.
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    CartModel.instance.clearCart();

    // Confirmation, then return all the way to Home.
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: green, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: darkNavy),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your order has been placed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: hintGrey),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Done',
                style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                  'Payment',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: darkNavy,
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Icon(Icons.lock_outline, size: 14, color: hintGrey),
                                SizedBox(width: 4),
                                Text(
                                  'Secure',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hintGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Card option (expanded with details when selected)
                        InkWell(
                          onTap: () => setState(() => _selectedMethod = _PaymentMethod.card),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _selectedMethod == _PaymentMethod.card
                                  ? const Color(0xFFF1F2FE)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedMethod == _PaymentMethod.card
                                    ? primaryBlue
                                    : borderGrey,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _selectedMethod == _PaymentMethod.card
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: _selectedMethod == _PaymentMethod.card
                                          ? primaryBlue
                                          : hintGrey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        '•••• •••• •••• 4242',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: darkNavy,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1F71),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'VISA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_selectedMethod == _PaymentMethod.card) ...[
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _CardDetailField(
                                          label: 'Expiry Date',
                                          value: '12/26',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _CardDetailField(
                                          label: 'CVV',
                                          value: '•••',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _PaymentMethodTile(
                          label: 'Apple Pay',
                          leading: const Icon(Icons.apple, size: 20, color: darkNavy),
                          selected: _selectedMethod == _PaymentMethod.applePay,
                          onTap: () => setState(() => _selectedMethod = _PaymentMethod.applePay),
                        ),
                        const SizedBox(height: 12),
                        _PaymentMethodTile(
                          label: 'PayPal',
                          leading: const Icon(Icons.account_balance_wallet_outlined,
                              size: 20, color: Color(0xFF003087)),
                          selected: _selectedMethod == _PaymentMethod.payPal,
                          onTap: () => setState(() => _selectedMethod = _PaymentMethod.payPal),
                        ),
                      ],
                    ),
                  ),
                ),

                // Total + Pay button
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderGrey)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: darkNavy,
                            ),
                          ),
                          Text(
                            '£${widget.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: darkNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _handlePay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: green.withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Pay £${widget.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified_user_outlined, size: 13, color: hintGrey),
                          SizedBox(width: 6),
                          Text(
                            'Your payment is 100% secure',
                            style: TextStyle(fontSize: 12, color: hintGrey),
                          ),
                        ],
                      ),
                    ],
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

class _CardDetailField extends StatelessWidget {
  final String label;
  final String value;
  const _CardDetailField({required this.label, required this.value});

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: hintGrey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderGrey),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: darkNavy),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String label;
  final Widget leading;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.label,
    required this.leading,
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1F2FE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkNavy,
                ),
              ),
            ),
            leading,
          ],
        ),
      ),
    );
  }
}