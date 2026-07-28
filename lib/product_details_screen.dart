import 'package:flutter/material.dart';

import 'cart_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color tealGreen = Color(0xFF17B37A);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  int _quantity = 1;
  bool _isFavorite = false;
  bool _descriptionExpanded = false;

  void _incrementQuantity() => setState(() => _quantity++);
  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
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
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.maybePop(context),
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.arrow_back, color: darkNavy, size: 22),
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _isFavorite = !_isFavorite),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorite ? Colors.redAccent : darkNavy,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Product image
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECEFF5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const _MedicineIllustration(),
                        ),
                        const SizedBox(height: 18),

                        // Name
                        const Text(
                          'Cetirizine 10mg Tablets',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'HealWell Pharmacy',
                          style: TextStyle(fontSize: 13, color: hintGrey),
                        ),
                        const SizedBox(height: 8),

                        // Rating
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                                  color: const Color(0xFFFFB020),
                                  size: 18,
                                );
                              }),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: darkNavy,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '(120 reviews)',
                              style: TextStyle(fontSize: 13, color: primaryBlue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Price + stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '£4.75',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: darkNavy,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: tealGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'In stock',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: tealGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: borderGrey),
                        const SizedBox(height: 16),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cetirizine is an antihistamine used to relieve allergy '
                          'symptoms such as runny nose, sneezing, and itching.'
                          '${_descriptionExpanded ? ' It works by blocking the effects of histamine, a substance the body produces during an allergic reaction, and typically starts working within an hour of taking it.' : ''}',
                          style: const TextStyle(fontSize: 13, color: hintGrey, height: 1.5),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => setState(() => _descriptionExpanded = !_descriptionExpanded),
                          child: Text(
                            _descriptionExpanded ? 'Show less' : 'Read more',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Dosage
                        const Text(
                          'Dosage',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Adults and children 6 years and over:\nOne 10mg tablet once daily.',
                          style: TextStyle(fontSize: 13, color: hintGrey, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom bar: quantity + add to cart
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderGrey)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _StepperButton(icon: Icons.remove, onTap: _decrementQuantity),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: darkNavy,
                                ),
                              ),
                            ),
                            _StepperButton(icon: Icons.add, onTap: _incrementQuantity),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              CartModel.instance.addItem(
                                name: 'Cetirizine 10mg Tablets',
                                pharmacy: 'HealWell Pharmacy',
                                price: 4.75,
                                icon: Icons.medication_liquid_outlined,
                                iconColor: primaryBlue,
                                quantity: _quantity,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added $_quantity to cart',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 16, color: const Color(0xFF1A1B3A)),
      ),
    );
  }
}

/// A stand-in medicine illustration (box + pills + hand), built from
/// shapes and icons so no external image asset is required.
class _MedicineIllustration extends StatelessWidget {
  const _MedicineIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Medicine box
        Positioned(
          left: 60,
          top: 40,
          child: Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 90,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD5DAE6)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: _ProductColors.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _ProductColors.tealGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Pills
        const Positioned(
          left: 100,
          bottom: 40,
          child: _Pill(),
        ),
        const Positioned(
          left: 130,
          bottom: 32,
          child: _Pill(),
        ),
        const Positioned(
          left: 160,
          bottom: 46,
          child: _Pill(),
        ),
        // Hand holding pills
        Positioned(
          right: 30,
          bottom: 20,
          child: Icon(Icons.back_hand_outlined, size: 64, color: Colors.brown.shade300),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD5DAE6)),
      ),
    );
  }
}

class _ProductColors {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color tealGreen = Color(0xFF17B37A);
}