// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcela.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParcelaAdapter extends TypeAdapter<Parcela> {
  @override
  final int typeId = 5;

  @override
  Parcela read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parcela(
      id: fields[0] as String,
      parcela: fields[1] as int,
      valor: fields[2] as double,
      codigo: fields[3] as String,
      nome: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Parcela obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.parcela)
      ..writeByte(2)
      ..write(obj.valor)
      ..writeByte(3)
      ..write(obj.codigo)
      ..writeByte(4)
      ..write(obj.nome);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParcelaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
