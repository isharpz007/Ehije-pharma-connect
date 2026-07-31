import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';
import 'order.dart';
import 'order_service.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color green = Color(0xFF1F8B3F);
  static const Color red = Color(0xFFEB5757);
  static const Color orange = Color(0xFFF6A623);
  static const Color blue = Color(0xFF3B82F6);

  late Future<List<OrderData>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = OrderService.instance.fetchMyOrders();
    });
  }

  Future<void> _handleRefresh() async {
    await OrderService.instance.fetchMyOrders();
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return green;
      case 'out_for_delivery':
        return blue;
      case 'preparing':
      case 'confirmed':
        return orange;
      case 'placed':
        return blue;
      case 'cancelled':
        return red;
      default:
        return primaryBlue;
    }
  }

  String _getStatusTitle(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return 'Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<OrderData>>(
                  future: _ordersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading orders: ${snapshot.error}',
                          style: TextStyle(fontSize: 14, color: hintGrey),
                        ),
                      );
                    }

                    final orders = snapshot.data ?? [];

                    if (orders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No orders yet',
                                style: TextStyle(fontSize: 16, color: hintGrey),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _refreshOrders,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final statusTitle = _getStatusTitle(order.status);
                        final statusColor = _getStatusColor(order.status);

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getOrderIcon(order.status),
                                color: statusColor,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              order.pharmacy,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: darkNavy,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${order.orderNumber}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hintGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(order.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hintGrey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '£${order.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    statusTitle,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OrderTrackingScreen(
                                    orderId: order.id.toString(),
                                    status: order.status,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const AppBottomNav(current: AppTab.orders),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getOrderIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'out_for_delivery':
        return Icons.local_shipping;
      case 'preparing':
      case 'confirmed':
        return Icons.restaurant_menu;
      case 'placed':
        return Icons.pending_actions;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }
}