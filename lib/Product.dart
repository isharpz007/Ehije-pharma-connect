/// A product row from Supabase's `products` table.
class Product {
  final int id;
  final String name;
  final String pharmacy;
  final String? category;
  final double price;
  final double? oldPrice;
  final bool inStock;
  final String? description;
  final String? dosage;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.pharmacy,
    this.category,
    required this.price,
    this.oldPrice,
    required this.inStock,
    this.description,
    this.dosage,
    this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      pharmacy: map['pharmacy'] as String,
      category: map['category'] as String?,
      price: (map['price'] as num).toDouble(),
      oldPrice: (map['old_price'] as num?)?.toDouble(),
      inStock: map['in_stock'] as bool? ?? true,
      description: map['description'] as String?,
      dosage: map['dosage'] as String?,
      imageUrl: map['image_url'] as String?,
    );
  }
}