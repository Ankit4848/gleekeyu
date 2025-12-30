import 'package:flutter/material.dart';

class CancellationPolicy extends StatelessWidget {
  const CancellationPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cancellation and Refunds',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildBulletPoint(
                'If you wish to cancel 45 to 30 days before the arrival date, you will be charged 5% cancellation charges** of the total property rent in the original payment mode.'),
            const SizedBox(height: 10),
            _buildBulletPoint(
                'Cancellations that are made between 29 to 15 days prior to the arrival date, 15% cancellation charges** of the total property rent.'),
            const SizedBox(height: 10),
            _buildBulletPoint(
                'Cancellations that are made between 14 to 7 days prior to the arrival date, 50% cancellation charges** of the total property rent.'),
            const SizedBox(height: 10),
            _buildBulletPoint(
                'For any cancellations requested within 6 days of the check-in date, the booking will be non-refundable.'),
            const SizedBox(height: 10),
            _buildBulletPoint(
                'A processing fee of 5% will be deducted from the refund amount as a convenience fee for cancellation.'),
            const SizedBox(height: 10),
            _buildBulletPoint(
                'Refund will be process within 6 to 7 working days.'),
            const SizedBox(height: 20),
            const Text(
              '**Please note: Cancellation fee is primarily applicable to cover platform charges, convenience fee and processing charges. Taxes as applicable.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.circle,
          color: Colors.orange,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}
