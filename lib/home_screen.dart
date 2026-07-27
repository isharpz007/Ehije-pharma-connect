import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'cart_model.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color blue = Color(0xFF3D7BF5);
  static const Color lightBlueBg = Color(0xFFE3EEFF);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(),
                    const SizedBox(height: 18),
                    _SearchBar(),
                    const SizedBox(height: 24),
                    const _HealthcareBanner(),
                    const SizedBox(height: 24),
                    _SectionHeader(title: 'Categories'),
                    const SizedBox(height: 14),
                    const _CategoryRow(),
                    const SizedBox(height: 24),
                    _SectionHeader(title: "Today's Deals"),
                    const SizedBox(height: 14),
                    const _DealsGrid(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const AppBottomNav(current: AppTab.home),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFDECEC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.location_on_outlined, color: Color(0xFFE0473F), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery to',
                style: TextStyle(fontSize: 12, color: HomeScreen.hintGrey),
              ),
              Row(
                children: const [
                  Text(
                    'Home, New York',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: HomeScreen.darkNavy,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 18, color: HomeScreen.darkNavy),
                ],
              ),
            ],
          ),
        ),
        _IconBadge(icon: Icons.notifications_none_rounded),
        const SizedBox(width: 10),
        AnimatedBuilder(
          animation: CartModel.instance,
          builder: (context, _) {
            return _IconBadge(
              icon: Icons.shopping_cart_outlined,
              badgeCount: CartModel.instance.itemCount,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final int? badgeCount;
  final VoidCallback? onTap;
  const _IconBadge({required this.icon, this.badgeCount, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: HomeScreen.darkNavy),
            ),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0473F),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, size: 20, color: HomeScreen.hintGrey),
            SizedBox(width: 8),
            Text(
              'Search for medicines...',
              style: TextStyle(fontSize: 13, color: HomeScreen.hintGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthcareBanner extends StatelessWidget {
  const _HealthcareBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HomeScreen.lightBlueBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Healthcare you\ncan trust',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: HomeScreen.darkNavy,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quality medicines\nat your doorstep',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5A6478), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _MedicineIllustration(),
        ],
      ),
    );
  }
}

/// Small illustration built from icons/shapes, standing in for
/// artwork of medicine bottles, blister packs and a dropper.
class _MedicineIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.medication_liquid, size: 66, color: HomeScreen.blue),
          const Positioned(
            top: 4,
            left: 6,
            child: Icon(Icons.grid_view_rounded, color: Colors.white, size: 18),
          ),
          Positioned(
            bottom: 4,
            right: 2,
            child: Icon(Icons.opacity, color: Colors.blue.shade300, size: 20),
          ),
          const Positioned(
            top: 0,
            right: 10,
            child: Icon(Icons.eco, color: Colors.green, size: 18),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: HomeScreen.darkNavy,
          ),
        ),
        Text(
          'View all',
          style: TextStyle(fontSize: 13, color: HomeScreen.blue, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  static const _categories = [
    (label: 'Pain Relief', icon: Icons.healing, color: Color(0xFFE3EEFF), iconColor: Color(0xFF3D7BF5)),
    (label: 'Vitamins', icon: Icons.medication, color: Color(0xFFFFF1DE), iconColor: Color(0xFFE8952B)),
    (label: 'Diabetes', icon: Icons.bloodtype, color: Color(0xFFE4F7E7), iconColor: Color(0xFF2FA84F)),
    (label: 'Baby Care', icon: Icons.child_care, color: Color(0xFFFDE7EE), iconColor: Color(0xFFE0477E)),
    (label: 'More', icon: Icons.add, color: Color(0xFFF4F6FB), iconColor: HomeScreen.darkNavy),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final c = _categories[index];
          return Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: c.color,
                  borderRadius: BorderRadius.circular(16),
                  border: c.label == 'More'
                      ? Border.all(color: const Color(0xFFE2E5EE), width: 1)
                      : null,
                ),
                child: Icon(c.icon, color: c.iconColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                c.label,
                style: const TextStyle(fontSize: 12, color: HomeScreen.darkNavy),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DealItem {
  final String name;
  final String location;
  final String price;
  final String? oldPrice;
  final String discount;
  final IconData icon;
  final Color iconColor;

  const _DealItem({
    required this.name,
    required this.location,
    required this.price,
    required this.discount,
    required this.icon,
    required this.iconColor,
    this.oldPrice,
  });
}

class _DealsGrid extends StatelessWidget {
  const _DealsGrid();

  static const _deals = [
    _DealItem(
      name: 'Paracetamol 500mg',
      location: 'MedPlus Pharmacy',
      price: '\$8',
      oldPrice: '\$12',
      discount: '23% off',
      icon: Icons.medication,
      iconColor: HomeScreen.blue,
    ),
    _DealItem(
      name: 'Vitamin C Tablets',
      location: 'MedPlus Pharmacy',
      price: '\$14',
      oldPrice: '\$20',
      discount: '29% off',
      icon: Icons.medication_liquid,
      iconColor: Color(0xFFE8952B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _deals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) => _DealCard(deal: _deals[index]),
    );
  }
}

class _DealCard extends StatelessWidget {
  final _DealItem deal;
  const _DealCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProductDetailsScreen()),
        );
      },
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(deal.icon, color: deal.iconColor, size: 42),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0473F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    deal.discount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.favorite_border, size: 18, color: HomeScreen.hintGrey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            deal.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: HomeScreen.darkNavy),
          ),
          const SizedBox(height: 2),
          Text(
            deal.location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: HomeScreen.hintGrey),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    deal.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: HomeScreen.darkNavy,
                    ),
                  ),
                  if (deal.oldPrice != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      deal.oldPrice!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: HomeScreen.hintGrey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: HomeScreen.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
