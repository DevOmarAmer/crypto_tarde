// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TradeRecordModelAdapter extends TypeAdapter<TradeRecordModel> {
  @override
  final int typeId = 1;

  @override
  TradeRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TradeRecordModel(
      id: fields[0] as String,
      type: fields[1] as String,
      coinId: fields[2] as String,
      symbol: fields[3] as String,
      quantity: fields[4] as double,
      price: fields[5] as double,
      total: fields[6] as double,
      timestamp: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TradeRecordModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.coinId)
      ..writeByte(3)
      ..write(obj.symbol)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
