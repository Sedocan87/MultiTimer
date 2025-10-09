// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_timer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinishedTimerModelAdapter extends TypeAdapter<FinishedTimerModel> {
  @override
  final int typeId = 2;

  @override
  FinishedTimerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinishedTimerModel(
      timer: fields[0] as TimerModel,
      finishedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FinishedTimerModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timer)
      ..writeByte(1)
      ..write(obj.finishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinishedTimerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
