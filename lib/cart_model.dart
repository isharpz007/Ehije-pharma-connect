import 'package:flutter/material.dart';

/// A single line item in the cart.
class CartItem {
  final String name;
  final String pharmacy;
  final double price;
  final IconData icon;
  final Color iconColor;
  int quantity;

  CartItem({
    required this.name,
    required this.pharmacy,
    required this.price,
    required this.icon,
    required this.iconColor,
    this.quantity = 1,
  });
}

/// App-wide cart state, shared by every screen.
///
/// This is a simple singleton `ChangeNotifier` rather than a full state
/// management package (Provider/Riverpod/Bloc) to keep the demo
/// self-contained — wrap screens in `AnimatedBuilder(animation:
/// CartModel.instance, ...)` wherever the UI needs to react to changes.
class CartModel extends ChangeNotifier {
  CartModel._internal();
  static final CartModel instance = CartModel._internal();

  static const double deliveryFee = 2.50;

  final List<CartItem> items = [];

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get total => items.isEmpty ? 0 : subtotal + deliveryFee;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Adds [quantity] of a product. If the product is already in the
  /// cart (matched by name), its quantity is increased instead of
  /// creating a duplicate row.
  void addItem({
    required String name,
    required String pharmacy,
    required double price,
    required IconData icon,
    required Color iconColor,
    int quantity = 1,
  }) {
    final existing = items.where((i) => i.name == name).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      items.add(CartItem(
        name: name,
        pharmacy: pharmacy,
        price: price,
        icon: icon,
        iconColor: iconColor,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void increment(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }
    notifyListeners();
  }

  /// Removes an item entirely, regardless of its quantity.
  void removeItem(CartItem item) {
    items.remove(item);
    notifyListeners();
  }

  /// Empties the cart, typically called after a successful payment.
  void clearCart() {
    items.clear();
    notifyListeners();
  }
}