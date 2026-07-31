import 'package:flutter/material.dart';

import 'address.dart';
import 'address_service.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  late Future<List<Address>> _future;

  @override
  void initState() {
    super.initState();
    _future = AddressService.instance.fetchMyAddresses();
  }

  void _refresh() {
    setState(() {
      _future = AddressService.instance.fetchMyAddresses();
    });
  }

  Future<void> _openEditor({Address? existing}) async {
    final labelController = TextEditingController(text: existing?.label ?? '');
    final line1Controller = TextEditingController(text: existing?.line1 ?? '');
    final line2Controller = TextEditingController(text: existing?.line2 ?? '');

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existing == null ? 'Add Address' : 'Edit Address',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: darkNavy),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Label (e.g. Home, Work)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: line1Controller,
                decoration: const InputDecoration(labelText: 'Address line 1'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: line2Controller,
                decoration: const InputDecoration(labelText: 'Address line 2 (city, country)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final label = labelController.text.trim();
                    final line1 = line1Controller.text.trim();
                    final line2 = line2Controller.text.trim();

                    if (label.isEmpty || line1.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in at least a label and address line')),
                      );
                      return;
                    }

                    if (existing == null) {
                      await AddressService.instance.addAddress(
                        label: label,
                        line1: line1,
                        line2: line2.isEmpty ? null : line2,
                      );
                    } else {
                      await AddressService.instance.updateAddress(
                        id: existing.id,
                        label: label,
                        line1: line1,
                        line2: line2.isEmpty ? null : line2,
                      );
                    }

                    if (context.mounted) Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.arrow_back, color: darkNavy, size: 20),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'My Addresses',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: darkNavy),
                    ),
                  ),
                  InkWell(
                    onTap: () => _openEditor(),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 18, color: primaryBlue),
                        SizedBox(width: 2),
                        Text(
                          'Add New',
                          style: TextStyle(fontSize: 13, color: primaryBlue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Address>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Could not load addresses: ${snapshot.error}',
                          style: const TextStyle(fontSize: 13, color: hintGrey),
                        ),
                      );
                    }

                    final addresses = snapshot.data ?? [];

                    if (addresses.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No saved addresses yet',
                              style: TextStyle(fontSize: 14, color: hintGrey),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => _openEditor(),
                              child: const Text('Add your first address'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        final selected = address.isDefault;
                        return InkWell(
                          onTap: () async {
                            await AddressService.instance.setDefault(address.id);
                            _refresh();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFFF1F2FE) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: selected ? primaryBlue : borderGrey),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: selected ? primaryBlue : hintGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.label,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: darkNavy,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        address.line1,
                                        style: const TextStyle(fontSize: 12, color: hintGrey),
                                      ),
                                      if (address.line2 != null && address.line2!.isNotEmpty)
                                        Text(
                                          address.line2!,
                                          style: const TextStyle(fontSize: 12, color: hintGrey),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => _deleteAddress(address.id),
                                  tooltip: 'Delete address',
                                ),
                                InkWell(
                                  onTap: () => _openEditor(existing: address),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAddress(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await AddressService.instance.deleteAddress(id);
                  _refresh();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Address deleted successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete address: $e')),
                    );
                  }
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}