/// An address row from Supabase's `addresses` table.
class Address {
  final int id;
  final String label;
  final String line1;
  final String? line2;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.line1,
    this.line2,
    required this.isDefault,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as int,
      label: map['label'] as String,
      line1: map['line1'] as String,
      line2: map['line2'] as String?,
      isDefault: map['is_default'] as bool? ?? false,
    );
  }
}