import 'package:flutter/material.dart';

class _TrackingStep {
  final String title;
  final String? time;
  final String? note;
  final bool done;

  const _TrackingStep({
    required this.title,
    this.time,
    this.note,
    required this.done,
  });
}

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final String status;

  const OrderTrackingScreen({super.key, required this.orderId, required this.status});

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  List<_TrackingStep> get _steps {
    final delivered = status == 'Delivered';
    return [
      const _TrackingStep(title: 'Order Placed', time: '1 May 2024, 10:30 AM', done: true),
      const _TrackingStep(title: 'Confirmed', time: '1 May 2024, 10:45 AM', done: true),
      const _TrackingStep(title: 'Preparing', time: '1 May 2024, 11:30 AM', done: true),
      _TrackingStep(
        title: 'Out for Delivery',
        time: '2 May 2024, 09:00 AM',
        done: true,
      ),
      _TrackingStep(
        title: 'Delivered',
        time: delivered ? '2 May 2024, 11:20 AM' : null,
        note: delivered ? 'Package delivered successfully' : null,
        done: delivered,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.maybePop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(Icons.arrow_back, color: darkNavy, size: 22),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Order Tracking',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: darkNavy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              orderId,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: darkNavy,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: status == 'Delivered' ? green : const Color(0xFFE08A00),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Expected delivery: 2 May 2024',
                          style: TextStyle(fontSize: 12, color: hintGrey),
                        ),
                        const SizedBox(height: 24),

                        // Timeline
                        for (int i = 0; i < _steps.length; i++)
                          _TimelineTile(
                            step: _steps[i],
                            isLast: i == _steps.length - 1,
                          ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderGrey)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: darkNavy,
                        side: const BorderSide(color: borderGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Order Details',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final _TrackingStep step;
  final bool isLast;

  const _TimelineTile({required this.step, required this.isLast});

  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color green = Color(0xFF1F8B3F);
  static const Color borderGrey = Color(0xFFE1E3EC);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: step.done ? green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: step.done ? green : borderGrey, width: 2),
                ),
                child: step.done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: step.done ? green : borderGrey,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: step.done ? darkNavy : hintGrey,
                    ),
                  ),
                  if (step.time != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.time!,
                      style: const TextStyle(fontSize: 12, color: hintGrey),
                    ),
                  ],
                  if (step.note != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        step.note!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}