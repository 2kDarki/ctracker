import 'package:flutter/material.dart';

import '../models/change_record.dart';
import '../utils/cleanup.dart';
import '../utils/time_format.dart';
import 'themed_text.dart';

class PaidRecordCard extends StatelessWidget {
  final ChangeRecord record;

  const PaidRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final success = Colors.green;
    final daysLeft = record.paidAt != null
        ? getDaysUntilDeletion(record.paidAt!)
        : 30;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ThemedText(
                  record.customerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ThemedText(
                '\$${record.amountOwed.toStringAsFixed(2)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: success),
                  const SizedBox(width: 4),
                  ThemedText(
                    record.paidAt != null
                        ? 'Paid ${DateTimeUtils.getRelativeTime(record.paidAt!)}'
                        : 'Paid',
                    type: TextType.small,
                    style: TextStyle(color: success),
                  ),
                ],
              ),
              ThemedText(
                'Removed in $daysLeft days',
                type: TextType.small,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
