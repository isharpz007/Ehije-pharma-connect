import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  static const _items = [
    (icon: Icons.help_outline, label: 'FAQs'),
    (icon: Icons.mail_outline, label: 'Contact Us'),
    (icon: Icons.local_shipping_outlined, label: 'Order Issues'),
    (icon: Icons.payment_outlined, label: 'Payment Issues'),
    (icon: Icons.assignment_return_outlined, label: 'Return & Refund'),
    (icon: Icons.flag_outlined, label: 'Report a Problem'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: darkNavy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              for (final item in _items) ...[
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 20, color: darkNavy),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: darkNavy,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 20, color: hintGrey),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, color: borderGrey),
              ],
            ],
          ),
        ),
      ),
    );
  }
}