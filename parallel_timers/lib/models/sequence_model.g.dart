// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sequence_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SequenceAdapter extends TypeAdapter<Sequence> {
  @override
  final int typeId = 1;

  @override
  Sequence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sequence(
      id: fields[0] as String,
      name: fields[1] as String,
      timers: (fields[2] as List).cast<TimerModel>(),
      icon: fields[3] as IconData,
      color: fields[4] as Color,
      isRunning: fields[5] as bool,
      currentTimerIndex: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sequence obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.timers)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.isRunning)
      ..writeByte(6)
      ..write(obj.currentTimerIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SequenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
