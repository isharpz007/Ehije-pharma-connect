import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'order_tracking_screen.dart';

class _Order {
  final String id;
  final String pharmacy;
  final String date;
  final String total;
  final String status; // Delivered, In Transit, Cancelled

  const _Order({
    required this.id,
    required this.pharmacy,
    required this.date,
    required this.total,
    required this.status,
  });
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  // static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  static const _orders = [
    _Order(
      id: '#PC-1024',
      pharmacy: 'GreenCare Pharmacy',
      date: '2 May 2024, 10:30 AM',
      total: '£19.99',
      status: 'Delivered',
    ),
    _Order(
      id: '#PC-1023',
      pharmacy: 'HealWell Pharmacy',
      date: '1 May 2024, 02:15 PM',
      total: '£15.50',
      status: 'In Transit',
    ),
    _Order(
      id: '#PC-1022',
      pharmacy: 'MediPlus Pharmacy',
      date: '28 Apr 2024, 09:20 AM',
      total: '£25.00',
      status: 'Delivered',
    ),
  ];

  static const _filters = ['All', 'Delivered', 'In Transit', 'Cancelled'];
  String _selectedFilter = 'All';

  Color _statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return green;
      case 'In Transit':
        return const Color(0xFFE08A00);
      case 'Cancelled':
        return const Color(0xFFE0473F);
      default:
        return hintGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = _selectedFilter == 'All'
        ? _orders
        : _orders.where((o) => o.status == _selectedFilter).toList();

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
                          'My Orders',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: darkNavy,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F6FB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.filter_list, size: 18, color: darkNavy),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filter chips
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final label = _filters[index];
                          final selected = label == _selectedFilter;
                          return InkWell(
                            onTap: () => setState(() => _selectedFilter = label),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? primaryBlue : const Color(0xFFF4F6FB),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : hintGrey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

                    if (visibleOrders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Text(
                            'No orders here yet',
                            style: TextStyle(fontSize: 14, color: hintGrey),
                          ),
                        ),
                      ),

                    for (final order in visibleOrders) ...[
                      _OrderCard(
                        order: order,
                        statusColor: _statusColor(order.status),
                        onViewDetails: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OrderTrackingScreen(
                                orderId: order.id,
                                status: order.status,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ),
            const AppBottomNav(current: AppTab.orders),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _Order order;
  final Color statusColor;
  final VoidCallback onViewDetails;

  const _OrderCard({
    required this.order,
    required this.statusColor,
    required this.onViewDetails,
  });

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color primaryBlue = Color(0xFF3B3FE0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: darkNavy,
                ),
              ),
              Text(
                order.status,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            order.pharmacy,
            style: const TextStyle(fontSize: 13, color: hintGrey),
          ),
          Text(
            order.date,
            style: const TextStyle(fontSize: 12, color: hintGrey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${order.total}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: darkNavy,
                ),
              ),
              InkWell(
                onTap: onViewDetails,
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}