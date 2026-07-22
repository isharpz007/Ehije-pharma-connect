import 'package:flutter/material.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  State<PrescriptionUploadScreen> createState() => _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);

  bool _fileSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                  const Text(
                    'Upload Prescription',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkNavy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              InkWell(
                onTap: () => setState(() => _fileSelected = !_fileSelected),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FE),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: borderGrey,
                      style: BorderStyle.solid,
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                        child: Icon(
                          _fileSelected ? Icons.check : Icons.cloud_upload_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _fileSelected ? 'prescription_scan.jpg selected' : 'Upload Prescription',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: darkNavy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'JPG, PNG or PDF (Max 5MB)',
                        style: TextStyle(fontSize: 12, color: hintGrey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Prescriptions are securely reviewed by our partner pharmacies.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: hintGrey, height: 1.4),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: !_fileSelected
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Prescription submitted for review')),
                          );
                          Navigator.maybePop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFC7CBD6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}