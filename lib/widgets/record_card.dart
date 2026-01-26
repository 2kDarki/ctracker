import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/change_record.dart';
import '../utils/time_format.dart';
import 'themed_text.dart';
import 'card.dart';

class RecordCard extends StatelessWidget {
  final ChangeRecord record;
  final VoidCallback onMarkPaid;

  const RecordCard({
    super.key,
    required this.record,
    required this.onMarkPaid,
  });

  String _formatAmount(double amount) => amount.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return CardContainer(
      background: Theme.of(context).colorScheme.surface,
      onTap: () {},
      child: Row(
        children: [
          Expanded(
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
                      '\$${_formatAmount(record.amountOwed)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ThemedText(
                  DateTimeUtils.getRelativeTime(record.createdAt),
                  type: TextType.small,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              onMarkPaid();
            },
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: primary, width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.check, size: 16, color: primary),
                ),
                const SizedBox(height: 4),
                ThemedText(
                  'Mark Paid',
                  type: TextType.small,
                  style: TextStyle(color: primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
