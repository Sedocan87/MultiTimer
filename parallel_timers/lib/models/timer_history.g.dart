// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerHistoryAdapter extends TypeAdapter<TimerHistory> {
  @override
  final int typeId = 1;

  @override
  TimerHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerHistory(
      id: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as Duration,
      completedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimerHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
