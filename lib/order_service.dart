import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_model.dart';
import 'order.dart';

/// Reads/writes orders in Supabase's `orders` and `order_items` tables.
class OrderService {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  /// All orders belonging to the currently logged-in user, newest first.
  Future<List<OrderData>> fetchMyOrders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => OrderData.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<OrderData?> fetchOrderById(int id) async {
    final response = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return OrderData.fromMap(response);
  }

  /// Creates an order (and its line items) in Supabase from whatever is
  /// currently in the cart, then empties the cart. Call this once
  /// payment succeeds.
  Future<OrderData> createOrderFromCart({
    required String pharmacy,
    required double deliveryFee,
    String? deliveryAddress,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('You need to be logged in to place an order.');
    }

    final cart = CartModel.instance;
    if (cart.items.isEmpty) {
      throw Exception('Your cart is empty.');
    }

    final subtotal = cart.subtotal;
    final total = subtotal + deliveryFee;
    final orderNumber = '#PC-${DateTime.now().millisecondsSinceEpoch % 100000}';

    final orderRow = await _client
        .from('orders')
        .insert({
          'order_number': orderNumber,
          'user_id': userId,
          'pharmacy': pharmacy,
          'status': 'placed',
          'subtotal': subtotal,
          'delivery_fee': deliveryFee,
          'total': total,
          'delivery_address': deliveryAddress,
        })
        .select()
        .single();

    final orderId = orderRow['id'] as int;

    for (final item in cart.items) {
      await _client.from('order_items').insert({
        'order_id': orderId,
        'product_id': item.productId,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      });
    }

    await cart.clearCart();

    return (await fetchOrderById(orderId))!;
  }
}