import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'categories_screen.dart';
import 'orders_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

enum AppTab { home, categories, orders, chat, profile }

/// The bottom navigation bar shared by the main app screens (Home,
/// Categories, Orders, Chat, Profile). Tapping a tab swaps to that
/// screen with `pushReplacement`, so the back stack doesn't pile up
/// as the user hops between tabs.
class AppBottomNav extends StatelessWidget {
  final AppTab? current;
  final int chatBadge;

  const AppBottomNav({super.key, this.current, this.chatBadge = 0});

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color hintGrey = Color(0xFF9B9FB1);

  void _navigate(BuildContext context, AppTab tab) {
    if (tab == current) return;
    late final Widget screen;
    switch (tab) {
      case AppTab.home:
        screen = const HomeScreen();
        break;
      case AppTab.categories:
        screen = const CategoriesScreen();
        break;
      case AppTab.orders:
        screen = const OrdersScreen();
        break;
      case AppTab.chat:
        screen = const ChatScreen();
        break;
      case AppTab.profile:
        screen = const ProfileScreen();
        break;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEFEFEF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavButton(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: current == AppTab.home,
            onTap: () => _navigate(context, AppTab.home),
          ),
          _NavButton(
            icon: Icons.grid_view_outlined,
            label: 'Categories',
            selected: current == AppTab.categories,
            onTap: () => _navigate(context, AppTab.categories),
          ),
          _NavButton(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            selected: current == AppTab.orders,
            onTap: () => _navigate(context, AppTab.orders),
          ),
          _NavButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            selected: current == AppTab.chat,
            badgeCount: chatBadge,
            onTap: () => _navigate(context, AppTab.chat),
          ),
          _NavButton(
            icon: Icons.person_outline,
            label: 'Profile',
            selected: current == AppTab.profile,
            onTap: () => _navigate(context, AppTab.profile),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppBottomNav.primaryBlue : AppBottomNav.hintGrey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color, size: 22),
              if (badgeCount > 0)
                Positioned(
                  top: -4,
                  right: -8,
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
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}