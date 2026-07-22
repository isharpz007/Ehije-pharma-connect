import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'search_results_screen.dart';

class _Category {
  final String label;
  final IconData icon;
  final Color color;
  const _Category({required this.label, required this.icon, required this.color});
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);

  static const _categories = [
    _Category(label: 'Pain Relief', icon: Icons.healing_outlined, color: Color(0xFFE9F3FD)),
    _Category(label: 'Vitamins', icon: Icons.eco_outlined, color: Color(0xFFFFF3E0)),
    _Category(label: 'Diabetes', icon: Icons.bloodtype_outlined, color: Color(0xFFE9F7EA)),
    _Category(label: 'Baby Care', icon: Icons.child_care_outlined, color: Color(0xFFFDECEC)),
    _Category(label: 'Skin Care', icon: Icons.face_retouching_natural, color: Color(0xFFFBEAEA)),
    _Category(label: 'Eye Care', icon: Icons.visibility_outlined, color: Color(0xFFE9F3FD)),
    _Category(label: 'First Aid', icon: Icons.medical_services_outlined, color: Color(0xFFFDECEC)),
    _Category(label: 'Supplements', icon: Icons.spa_outlined, color: Color(0xFFE9F7EA)),
    _Category(label: "Women's Health", icon: Icons.favorite_border, color: Color(0xFFFBEAEA)),
    _Category(label: "Men's Health", icon: Icons.shield_outlined, color: Color(0xFFE9F3FD)),
    _Category(label: 'Other', icon: Icons.more_horiz, color: Color(0xFFF4F6FB)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: darkNavy,
                      ),
                    ),
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
                        );
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6FB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, size: 20, color: hintGrey),
                            SizedBox(width: 8),
                            Text(
                              'Search categories',
                              style: TextStyle(fontSize: 13, color: hintGrey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final c = _categories[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: c.color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(c.icon, color: darkNavy, size: 26),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c.label,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: darkNavy, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNav(current: AppTab.categories),
          ],
        ),
      ),
    );
  }
}