import 'package:flutter/material.dart';

import 'cart_model.dart';

class _SearchResult {
  final String name;
  final String pharmacy;
  final double price;
  final String status;
  final IconData icon;
  final Color iconColor;

  const _SearchResult({
    required this.name,
    required this.pharmacy,
    required this.price,
    required this.status,
    required this.icon,
    required this.iconColor,
  });
}

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  // static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  // static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  final TextEditingController _searchController = TextEditingController(text: 'Ibuprofen');

  static const _allResults = [
    _SearchResult(
      name: 'Ibuprofen 200mg',
      pharmacy: 'HealWell Pharmacy',
      price: 3.20,
      status: 'In stock',
      icon: Icons.medication_outlined,
      iconColor: primaryBlue,
    ),
    _SearchResult(
      name: 'Ibuprofen 400mg',
      pharmacy: 'GreenCare Pharmacy',
      price: 3.50,
      status: 'In stock',
      icon: Icons.medication_liquid_outlined,
      iconColor: green,
    ),
    _SearchResult(
      name: 'Ibuprofen Syrup',
      pharmacy: 'MediPlus Pharmacy',
      price: 4.20,
      status: 'In stock',
      icon: Icons.local_drink_outlined,
      iconColor: Colors.orange,
    ),
  ];

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
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Search medicines...',
                                hintStyle: TextStyle(fontSize: 13, color: hintGrey),
                              ),
                              onChanged: (_) => setState(() {}),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_allResults.length} results found',
                  style: const TextStyle(fontSize: 13, color: hintGrey),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: _allResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _ResultTile(result: _allResults[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final _SearchResult result;
  const _ResultTile({required this.result});

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

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
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderGrey),
            ),
            child: Icon(result.icon, color: result.iconColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: darkNavy),
                ),
                const SizedBox(height: 2),
                Text(
                  result.pharmacy,
                  style: const TextStyle(fontSize: 12, color: hintGrey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '£${result.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: darkNavy),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      result.status,
                      style: const TextStyle(fontSize: 11, color: green, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              CartModel.instance.addItem(
                name: result.name,
                pharmacy: result.pharmacy,
                price: result.price,
                icon: result.icon,
                iconColor: result.iconColor,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added ${result.name} to cart'), duration: const Duration(seconds: 1)),
              );
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}