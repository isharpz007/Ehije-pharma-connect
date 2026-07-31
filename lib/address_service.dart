import 'package:supabase_flutter/supabase_flutter.dart';

import 'address.dart';

/// Reads/writes the current user's addresses in Supabase.
class AddressService {
  AddressService._internal();
  static final AddressService instance = AddressService._internal();

  SupabaseClient get _client => Supabase.instance.client;
  String? get _userId => _client.auth.currentUser?.id;

  Future<List<Address>> fetchMyAddresses() async {
    final userId = _userId;
    if (userId == null) return [];

    final response = await _client
        .from('addresses')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((row) => Address.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  /// The address currently marked as default, if any.
  Future<Address?> fetchDefaultAddress() async {
    final addresses = await fetchMyAddresses();
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }

  Future<void> addAddress({
    required String label,
    required String line1,
    String? line2,
    bool makeDefault = false,
  }) async {
    final userId = _userId;
    if (userId == null) throw Exception('You need to be logged in.');

    if (makeDefault) {
      await _clearDefaults(userId);
    }

    await _client.from('addresses').insert({
      'user_id': userId,
      'label': label,
      'line1': line1,
      'line2': line2,
      'is_default': makeDefault,
    });
  }

  Future<void> updateAddress({
    required int id,
    required String label,
    required String line1,
    String? line2,
  }) async {
    await _client.from('addresses').update({
      'label': label,
      'line1': line1,
      'line2': line2,
    }).eq('id', id);
  }

  Future<void> setDefault(int id) async {
    final userId = _userId;
    if (userId == null) return;

    await _clearDefaults(userId);
    await _client.from('addresses').update({'is_default': true}).eq('id', id);
  }

  Future<void> deleteAddress(int id) async {
    await _client.from('addresses').delete().eq('id', id);
  }

  Future<void> _clearDefaults(String userId) async {
    await _client
        .from('addresses')
        .update({'is_default': false})
        .eq('user_id', userId);
  }
}