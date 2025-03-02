// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PedidoAdapter extends TypeAdapter<Pedido> {
  @override
  final int typeId = 1;

  @override
  Pedido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pedido(
      id: fields[0] as String,
      numero: fields[1] as int,
      dataCriacao: fields[2] as String,
      dataAlteracao: fields[3] as String,
      status: fields[4] as String,
      desconto: fields[5] as double,
      frete: fields[6] as double,
      subTotal: fields[7] as double,
      valorTotal: fields[8] as double,
      cliente: fields[9] as Cliente,
      enderecoEntrega: fields[10] as Endereco,
      itens: (fields[11] as List).cast<Item>(),
      pagamento: (fields[12] as List).cast<Parcela>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pedido obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.numero)
      ..writeByte(2)
      ..write(obj.dataCriacao)
      ..writeByte(3)
      ..write(obj.dataAlteracao)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.desconto)
      ..writeByte(6)
      ..write(obj.frete)
      ..writeByte(7)
      ..write(obj.subTotal)
      ..writeByte(8)
      ..write(obj.valorTotal)
      ..writeByte(9)
      ..write(obj.cliente)
      ..writeByte(10)
      ..write(obj.enderecoEntrega)
      ..writeByte(11)
      ..write(obj.itens)
      ..writeByte(12)
      ..write(obj.pagamento);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PedidoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
