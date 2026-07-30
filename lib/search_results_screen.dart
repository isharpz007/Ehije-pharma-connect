import 'package:flutter/material.dart';

import 'cart_model.dart';
import 'product.dart';
import 'product_details_screen.dart';
import 'product_service.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? initialCategory;
  const SearchResultsScreen({super.key, this.initialCategory});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color hintGrey = Color(0xFF9B9FB1);

  final TextEditingController _searchController = TextEditingController();
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialCategory ?? '';
    _future = widget.initialCategory != null
        ? ProductService.instance.fetchByCategory(widget.initialCategory!)
        : ProductService.instance.fetchAll();
  }

  void _runSearch(String query) {
    setState(() {
      _future = ProductService.instance.search(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 20, color: hintGrey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: widget.initialCategory == null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Search medicines...',
                                hintStyle: TextStyle(fontSize: 13, color: hintGrey),
                              ),
                              onSubmitted: _runSearch,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, color: primaryBlue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong: ${snapshot.error}',
                        style: const TextStyle(fontSize: 13, color: hintGrey),
                      ),
                    );
                  }

                  final results = snapshot.data ?? [];

                  if (results.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(fontSize: 14, color: hintGrey),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    children: [
                      Text(
                        '${results.length} results found',
                        style: const TextStyle(fontSize: 13, color: hintGrey),
                      ),
                      const SizedBox(height: 12),
                      for (final product in results) ...[
                        _ResultTile(product: product),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final Product product;
  const _ResultTile({required this.product});

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderGrey),
              ),
              child: const Icon(Icons.medication_outlined, color: primaryBlue, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: darkNavy),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.pharmacy,
                    style: const TextStyle(fontSize: 12, color: hintGrey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '£${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: darkNavy),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.inStock ? 'In stock' : 'Out of stock',
                        style: TextStyle(
                          fontSize: 11,
                          color: product.inStock ? green : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: !product.inStock
                  ? null
                  : () {
                      CartModel.instance.addItem(
                        product: product,
                        icon: Icons.medication_outlined,
                        iconColor: primaryBlue,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${product.name} to cart'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: product.inStock ? primaryBlue : hintGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}