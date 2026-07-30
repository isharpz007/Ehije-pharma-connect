import 'package:flutter/material.dart';

import 'cart_model.dart';
import 'product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

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

  void _incrementQuantity() => setState(() => _quantity++);
  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECEFF5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(Icons.medication, size: 64, color: primaryBlue),
                                  ),
                                )
                              : const Icon(Icons.medication, size: 64, color: primaryBlue),
                        ),
                        const SizedBox(height: 18),

                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.pharmacy,
                          style: const TextStyle(fontSize: 13, color: hintGrey),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '£${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: darkNavy,
                                  ),
                                ),
                                if (product.oldPrice != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '£${product.oldPrice!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: hintGrey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: product.inStock ? tealGreen : Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  product.inStock ? 'In stock' : 'Out of stock',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: product.inStock ? tealGreen : Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: borderGrey),
                        const SizedBox(height: 16),

                        if (product.description != null && product.description!.isNotEmpty) ...[
                          const Text(
                            'Description',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: darkNavy),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description!,
                            style: const TextStyle(fontSize: 13, color: hintGrey, height: 1.5),
                          ),
                          const SizedBox(height: 20),
                        ],

                        if (product.dosage != null && product.dosage!.isNotEmpty) ...[
                          const Text(
                            'Dosage',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: darkNavy),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.dosage!,
                            style: const TextStyle(fontSize: 13, color: hintGrey, height: 1.5),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

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
                            onPressed: !product.inStock
                                ? null
                                : () {
                                    CartModel.instance.addItem(
                                      product: product,
                                      icon: Icons.medication,
                                      iconColor: primaryBlue,
                                      quantity: _quantity,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Added $_quantity to cart'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFC7CBD6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              product.inStock ? 'Add to Cart' : 'Out of Stock',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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