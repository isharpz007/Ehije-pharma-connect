import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'product.dart';

/// A single line item in the cart, backed by a row in Supabase's
/// `cart_items` table (joined with `products` for display info).
class CartItem {
  final int productId;
  final String name;
  final String pharmacy;
  final double price;
  final IconData icon;
  final Color iconColor;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.pharmacy,
    required this.price,
    required this.icon,
    required this.iconColor,
    this.quantity = 1,
  });
}

/// App-wide cart state, synced with Supabase so it survives app
/// restarts and works across devices for the same logged-in user.
///
/// Every mutation (add/increment/decrement/remove/clear) updates
/// local state immediately for a snappy UI, then writes the same
/// change to Supabase in the background.
class CartModel extends ChangeNotifier {
  CartModel._internal();
  static final CartModel instance = CartModel._internal();

  static const double deliveryFee = 2.50;

  final List<CartItem> items = [];

  SupabaseClient get _client => Supabase.instance.client;
  String? get _userId => _client.auth.currentUser?.id;

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get total => items.isEmpty ? 0 : subtotal + deliveryFee;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Call this after login (and on app start if already logged in) to
  /// pull the user's saved cart down from Supabase into local state.
  Future<void> loadFromSupabase() async {
    final userId = _userId;
    if (userId == null) return;

    final response = await _client
        .from('cart_items')
        .select('quantity, products(id, name, pharmacy, price)')
        .eq('user_id', userId);

    items.clear();

    for (final row in response as List) {
      final product = row['products'] as Map<String, dynamic>?;
      if (product == null) continue;

      items.add(CartItem(
        productId: product['id'] as int,
        name: product['name'] as String,
        pharmacy: product['pharmacy'] as String,
        price: (product['price'] as num).toDouble(),
        icon: Icons.medication_outlined,
        iconColor: const Color(0xFF3B3FE0),
        quantity: row['quantity'] as int,
      ));
    }

    notifyListeners();
  }

  Future<void> addItem({
    required Product product,
    required IconData icon,
    required Color iconColor,
    int quantity = 1,
  }) async {
    final existing = items.where((i) => i.productId == product.id).toList();

    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      items.add(CartItem(
        productId: product.id,
        name: product.name,
        pharmacy: product.pharmacy,
        price: product.price,
        icon: icon,
        iconColor: iconColor,
        quantity: quantity,
      ));
    }
    notifyListeners();

    final userId = _userId;
    if (userId == null) return;

    final newQuantity =
        items.firstWhere((i) => i.productId == product.id).quantity;

    await _client.from('cart_items').upsert(
      {
        'user_id': userId,
        'product_id': product.id,
        'quantity': newQuantity,
        'updated_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user_id,product_id',
    );
  }

  Future<void> increment(CartItem item) async {
    item.quantity++;
    notifyListeners();
    await _syncQuantity(item);
  }

  Future<void> decrement(CartItem item) async {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
      await _syncQuantity(item);
    } else {
      await removeItem(item);
    }
  }

  Future<void> removeItem(CartItem item) async {
    items.remove(item);
    notifyListeners();

    final userId = _userId;
    if (userId == null) return;

    await _client
        .from('cart_items')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', item.productId);
  }

  Future<void> clearCart() async {
    items.clear();
    notifyListeners();

    final userId = _userId;
    if (userId == null) return;

    await _client.from('cart_items').delete().eq('user_id', userId);
  }

  Future<void> _syncQuantity(CartItem item) async {
    final userId = _userId;
    if (userId == null) return;

    await _client
        .from('cart_items')
        .update({
          'quantity': item.quantity,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('product_id', item.productId);
  }
}