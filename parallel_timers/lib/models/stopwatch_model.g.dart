// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stopwatch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopwatchModelAdapter extends TypeAdapter<StopwatchModel> {
  @override
  final int typeId = 3;

  @override
  StopwatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopwatchModel(
      isRunning: fields[0] as bool,
      elapsed: fields[1] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, StopwatchModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isRunning)
      ..writeByte(1)
      ..write(obj.elapsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopwatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
