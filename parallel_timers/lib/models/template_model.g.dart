// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerTemplateAdapter extends TypeAdapter<TimerTemplate> {
  @override
  final int typeId = 4;

  @override
  TimerTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerTemplate(
      id: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as int,
      color: fields[3] as Color,
      icon: fields[4] as IconData,
      category: fields[5] as String,
      isPredefined: fields[6] as bool,
      order: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimerTemplate obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.isPredefined)
      ..writeByte(7)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
