// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerModelAdapter extends TypeAdapter<TimerModel> {
  @override
  final int typeId = 0;

  @override
  TimerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerModel(
      id: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as Duration,
      remainingTime: fields[3] as Duration,
      isRunning: fields[4] as bool,
      color: fields[5] as Color,
      icon: fields[6] as IconData,
      vibrationPattern: (fields[7] as List?)?.cast<int>(),
      isSequence: fields[8] as bool,
      sequenceId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TimerModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.remainingTime)
      ..writeByte(4)
      ..write(obj.isRunning)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.vibrationPattern)
      ..writeByte(8)
      ..write(obj.isSequence)
      ..writeByte(9)
      ..write(obj.sequenceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
