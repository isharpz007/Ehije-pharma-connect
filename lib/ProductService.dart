import 'package:supabase_flutter/supabase_flutter.dart';

import 'product.dart';

/// Reads products from Supabase's `products` table. Adding or
/// removing a row in the Supabase Table Editor is reflected here
/// automatically — there's no separate "sync" step.
class ProductService {
  ProductService._internal();
  static final ProductService instance = ProductService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Product>> fetchAll() async {
    final response = await _client
        .from('products')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => Product.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> fetchByCategory(String category) async {
    final response = await _client
        .from('products')
        .select()
        .eq('category', category)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => Product.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> search(String query) async {
    if (query.trim().isEmpty) return fetchAll();

    final response = await _client
        .from('products')
        .select()
        .ilike('name', '%$query%')
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => Product.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<Product?> fetchById(int id) async {
    final response =
        await _client.from('products').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Product.fromMap(response);
  }
}