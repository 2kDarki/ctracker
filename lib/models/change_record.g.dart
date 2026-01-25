// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChangeRecordAdapter extends TypeAdapter<ChangeRecord> {
  @override
  final int typeId = 0;

  @override
  ChangeRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChangeRecord(
      id: fields[0] as String,
      customerName: fields[1] as String,
      amountOwed: fields[2] as double,
      createdAt: fields[3] as DateTime,
      isPaid: fields[4] as bool,
      paidAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChangeRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.amountOwed)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isPaid)
      ..writeByte(5)
      ..write(obj.paidAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
