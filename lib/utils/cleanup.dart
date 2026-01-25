import '../models/change_record.dart';
import '../stores/change_record_store.dart';

const int DAYS_TO_KEEP_PAID = 30;

/// Deletes paid records older than [DAYS_TO_KEEP_PAID].
/// Returns the number of records deleted.
Future<int> cleanupPaidRecords(ChangeRecordStore store) async {
  final records = store.activeRecords + store.paidRecords;
  final now = DateTime.now();

  final recordsToDelete = <String>[];

  for (final record in records) {
    if (record.isPaid && record.paidAt != null) {
      final paidDate = record.paidAt!;
      final daysSincePaid = now.difference(paidDate).inDays;

      if (daysSincePaid >= DAYS_TO_KEEP_PAID) {
        recordsToDelete.add(record.id);
      }
    }
  }

  if (recordsToDelete.isNotEmpty) {
    await store.deleteRecords(recordsToDelete);
  }

  return recordsToDelete.length;
}

/// Returns only active (unpaid) records, sorted by creation date ascending.
List<ChangeRecord> getActiveRecords(List<ChangeRecord> records) {
  final active = records.where((r) => !r.isPaid).toList();
  active.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return active;
}

/// Returns only paid records with [paidAt] set, sorted by paid date descending.
List<ChangeRecord> getPaidRecords(List<ChangeRecord> records) {
  final paid = records.where((r) => r.isPaid && r.paidAt != null).toList();
  paid.sort((a, b) => b.paidAt!.compareTo(a.paidAt!));
  return paid;
}

/// Filters records whose customer name contains [query] (case-insensitive)
List<ChangeRecord> searchRecords(List<ChangeRecord> records, String query) {
  if (query.trim().isEmpty) return records;

  final lowerQuery = query.toLowerCase().trim();
  return records
      .where((r) => r.customerName.toLowerCase().contains(lowerQuery))
      .toList();
}

/// Returns the number of days remaining before a paid record is eligible for deletion.
int getDaysUntilDeletion(DateTime paidAt) {
  final now = DateTime.now();
  final daysSincePaid = now.difference(paidAt).inDays;
  return (DAYS_TO_KEEP_PAID - daysSincePaid).clamp(0, DAYS_TO_KEEP_PAID);
}
