// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countdown_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountdownAdapter extends TypeAdapter<Countdown> {
  @override
  final int typeId = 6;

  @override
  Countdown read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Countdown(
      name: fields[1] as String,
      targetDate: fields[2] as DateTime,
      color: fields[3] as Color?,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, Countdown obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.targetDate)
      ..writeByte(3)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountdownAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
