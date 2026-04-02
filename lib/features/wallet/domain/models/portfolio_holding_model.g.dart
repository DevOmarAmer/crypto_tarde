// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_holding_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioHoldingModelAdapter extends TypeAdapter<PortfolioHoldingModel> {
  @override
  final int typeId = 0;

  @override
  PortfolioHoldingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioHoldingModel(
      coinId: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
      logoUrl: fields[3] as String,
      quantity: fields[4] as double,
      avgBuyPrice: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioHoldingModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.coinId)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.logoUrl)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.avgBuyPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioHoldingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
