import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/change_record.dart';

class ChangeRecordStore extends ChangeNotifier {
  static const String _boxName = 'changes';
  final Box<ChangeRecord> _box;

  ChangeRecordStore._(this._box);

  // Factory to initialize the store
  static Future<ChangeRecordStore> create() async {
    final box = await Hive.openBox<ChangeRecord>(_boxName);
    final store = ChangeRecordStore._(box);
    await store.purgeOldRecords(); // optional cleanup
    return store;
  }

  // getters for active/paid records
  List<ChangeRecord> get activeRecords => _box.values
      .where((r) => !r.isPaid)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<ChangeRecord> get paidRecords => _box.values
      .where((r) => r.isPaid)
      .toList()
    ..sort((a, b) => b.paidAt!.compareTo(a.paidAt!));

  // Add a new record
  Future<void> addRecord(ChangeRecord record) async {
    await _box.put(record.id, record);
    notifyListeners();
  }

  // Update an existing record
  Future<void> updateRecord(ChangeRecord record) async {
    await _box.put(record.id, record);
    notifyListeners();
  }

  // Delete single/multiple records
  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> deleteRecords(List<String> ids) async {
    for (final id in ids) {
      await _box.delete(id);
    }
    notifyListeners();
  }

  // Purge old paid records
  Future<void> purgeOldRecords() async {
    final now = DateTime.now();
    final idsToDelete = _box.values
        .where((r) => r.isPaid && r.paidAt != null)
        .where((r) => now.difference(r.paidAt!).inDays > 30)
        .map((r) => r.id)
        .toList();
    await deleteRecords(idsToDelete);
  }
}
