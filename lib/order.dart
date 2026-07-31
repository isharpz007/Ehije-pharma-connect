/// A single line item within an order.
class OrderItemData {
  final int id;
  final int? productId;
  final String name;
  final double price;
  final int quantity;

  const OrderItemData({
    required this.id,
    this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItemData.fromMap(Map<String, dynamic> map) {
    return OrderItemData(
      id: map['id'] as int,
      productId: map['product_id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}

/// An order row from Supabase's `orders` table, with its line items
/// (`order_items`) joined in.
class OrderData {
  final int id;
  final String orderNumber;
  final String pharmacy;
  final String status; // placed, confirmed, preparing, out_for_delivery, delivered, cancelled
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? deliveryAddress;
  final DateTime createdAt;
  final List<OrderItemData> items;

  const OrderData({
    required this.id,
    required this.orderNumber,
    required this.pharmacy,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.deliveryAddress,
    required this.createdAt,
    required this.items,
  });

  factory OrderData.fromMap(Map<String, dynamic> map) {
    final itemsList = (map['order_items'] as List? ?? [])
        .map((e) => OrderItemData.fromMap(e as Map<String, dynamic>))
        .toList();

    return OrderData(
      id: map['id'] as int,
      orderNumber: map['order_number'] as String,
      pharmacy: map['pharmacy'] as String,
      status: map['status'] as String,
      subtotal: (map['subtotal'] as num).toDouble(),
      deliveryFee: (map['delivery_fee'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      deliveryAddress: map['delivery_address'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      items: itemsList,
    );
  }
}