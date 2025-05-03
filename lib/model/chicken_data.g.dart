// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chicken_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChickenDataAdapter extends TypeAdapter<ChickenData> {
  @override
  final int typeId = 0;

  @override
  ChickenData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChickenData(
      umur: fields[0] as int,
      berat: fields[1] as double,
      habisPakan: fields[2] as double,
      matiAyam: fields[3] as int,
      fcr: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ChickenData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.umur)
      ..writeByte(1)
      ..write(obj.berat)
      ..writeByte(2)
      ..write(obj.habisPakan)
      ..writeByte(3)
      ..write(obj.matiAyam)
      ..writeByte(4)
      ..write(obj.fcr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChickenDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
