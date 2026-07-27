import 'package:flutter/material.dart';

class _Address {
  final String label;
  final String line1;
  final String line2;

  const _Address({required this.label, required this.line1, required this.line2});
}

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

  static const _addresses = [
    _Address(label: 'Home', line1: '14 Rosewood Ave, NW1', line2: 'London, United Kingdom'),
    _Address(label: 'Work', line1: 'Office 12, King Street', line2: 'London, United Kingdom'),
  ];

  int _selectedIndex = 0;

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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: darkNavy,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
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
                child: ListView.separated(
                  itemCount: _addresses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    final selected = index == _selectedIndex;
                    return InkWell(
                      onTap: () => setState(() => _selectedIndex = index),
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
                                  Text(
                                    address.line2,
                                    style: const TextStyle(fontSize: 12, color: hintGrey),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {},
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}