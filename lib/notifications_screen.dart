import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  bool read = false;

 _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  // static const Color hintGrey = Color(0xFF9B9FB1);
  // static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      title: 'Order Delivered',
      message: '#PC-1024 has been delivered',
      time: '2 May 2024, 11:20 AM',
      icon: Icons.check_circle_outline,
      iconColor: green,
      iconBg: const Color(0xFFE9F7EA),
    ),
    _NotificationItem(
      title: 'Order Update',
      message: '#PC-1025 is on the way',
      time: '2 May 2024, 09:15 AM',
      icon: Icons.local_shipping_outlined,
      iconColor: primaryBlue,
      iconBg: const Color(0xFFE9F3FD),
    ),
    _NotificationItem(
      title: 'Pharmacy Message',
      message: 'GreenCare Pharmacy replied to your message',
      time: '1 May 2024, 08:30 AM',
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.orange,
      iconBg: const Color(0xFFFFF3E0),
    ),
    _NotificationItem(
      title: 'Special Offer',
      message: '20% off on all vitamins',
      time: '30 Apr 2024, 10:00 AM',
      icon: Icons.local_offer_outlined,
      iconColor: Colors.purple,
      iconBg: const Color(0xFFF3E9FD),
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.read = true;
      }
    });
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: darkNavy,
                          ),
                        ),
                        InkWell(
                          onTap: _markAllRead,
                          child: const Text(
                            'Mark all as read',
                            style: TextStyle(fontSize: 13, color: primaryBlue, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    for (final n in _notifications) ...[
                      _NotificationTile(
                        item: n,
                        onTap: () => setState(() => n.read = true),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            const AppBottomNav(current: AppTab.chat, chatBadge: 1),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color primaryBlue = Color(0xFF3B3FE0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.read ? Colors.white : const Color(0xFFF7F8FE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: item.iconBg, shape: BoxShape.circle),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: darkNavy),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.message,
                    style: const TextStyle(fontSize: 12, color: hintGrey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: const TextStyle(fontSize: 11, color: hintGrey),
                  ),
                ],
              ),
            ),
            if (!item.read)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}