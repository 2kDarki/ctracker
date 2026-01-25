// models/change_record.dart
import 'dart:math';
import 'package:hive/hive.dart';

part 'change_record.g.dart'; // Required for Hive code generation

@HiveType(typeId: 0)
class ChangeRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final double amountOwed;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  bool isPaid;

  @HiveField(5)
  DateTime? paidAt;

  ChangeRecord({
    required this.id,
    required this.customerName,
    required this.amountOwed,
    required this.createdAt,
    this.isPaid = false,
    this.paidAt,
  });

  // Factory to create a new record with guards
  factory ChangeRecord.create({required String customerName, required double amountOwed}) {
    if (customerName.trim().isEmpty) {
      throw ArgumentError('customerName cannot be empty');
    }
    if (amountOwed < 0) {
      throw ArgumentError('amountOwed cannot be negative');
    }

    return ChangeRecord(
      id: _generateUUID(),
      customerName: customerName.trim(),
      amountOwed: amountOwed,
      createdAt: DateTime.now(),
      isPaid: false,
      paidAt: null,
    );
  }

  void markAsPaid() {
    if (!isPaid) {
      isPaid = true;
      paidAt = DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'amountOwed': amountOwed,
      'createdAt': createdAt.toIso8601String(),
      'isPaid': isPaid,
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  factory ChangeRecord.fromMap(Map<String, dynamic> map) {
    return ChangeRecord(
      id: map['id'] ?? _generateUUID(),
      customerName: map['customerName'] ?? '',
      amountOwed: (map['amountOwed'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      isPaid: map['isPaid'] ?? false,
      paidAt: map['paidAt'] != null ? DateTime.tryParse(map['paidAt']) : null,
    );
  }

  // Dart-native UUID generator
  static String _generateUUID() {
    final random = Random();
    const hexDigits = '0123456789abcdef';
    String generate(int length) =>
        List.generate(length, (_) => hexDigits[random.nextInt(16)]).join();

    final timeLow = generate(8);
    final timeMid = generate(4);
    final timeHiAndVersion = '4' + generate(3);
    final clockSeq = (random.nextInt(4) + 8).toRadixString(16) + generate(3);
    final node = generate(12);

    return '$timeLow-$timeMid-$timeHiAndVersion-$clockSeq-$node';
  }
}
