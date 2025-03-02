library desafio_pedidos.models.Pedido;

import 'package:hive/hive.dart';
import 'cliente.dart';
import 'endereco.dart';
import 'item.dart';
import 'parcela.dart';

part 'pedido.g.dart';

@HiveType(typeId: 1)
class Pedido {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int numero;

  @HiveField(2)
  final String dataCriacao;

  @HiveField(3)
  final String dataAlteracao;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final double desconto;

  @HiveField(6)
  final double frete;

  @HiveField(7)
  final double subTotal;

  @HiveField(8)
  final double valorTotal;

  @HiveField(9)
  final Cliente cliente;

  @HiveField(10)
  final Endereco enderecoEntrega;

  @HiveField(11)
  final List<Item> itens;

  @HiveField(12)
  final List<Parcela> pagamento;

  Pedido({
    required this.id,
    required this.numero,
    required this.dataCriacao,
    required this.dataAlteracao,
    required this.status,
    required this.desconto,
    required this.frete,
    required this.subTotal,
    required this.valorTotal,
    required this.cliente,
    required this.enderecoEntrega,
    required this.itens,
    required this.pagamento,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    var listItens = json['itens'] as List;
    var listPagamento = json['pagamento'] as List;

    return Pedido(
      id: json['id'] ?? '',
      numero: json['numero'] ?? 0,
      dataCriacao: json['dataCriacao'] ?? '',
      dataAlteracao: json['dataAlteracao'] ?? '',
      status: json['status'] ?? '',
      desconto: (json['desconto'] ?? 0).toDouble(),
      frete: (json['frete'] ?? 0).toDouble(),
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      valorTotal: (json['valorTotal'] ?? 0).toDouble(),
      cliente: Cliente.fromJson(json['cliente'] ?? {}),
      enderecoEntrega: Endereco.fromJson(json['enderecoEntrega'] ?? {}),
      itens: listItens.map((item) => Item.fromJson(item)).toList(),
      pagamento:
          listPagamento.map((parcela) => Parcela.fromJson(parcela)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'dataCriacao': dataCriacao,
      'dataAlteracao': dataAlteracao,
      'status': status,
      'desconto': desconto,
      'frete': frete,
      'subTotal': subTotal,
      'valorTotal': valorTotal,
      'cliente': cliente.toJson(),
      'enderecoEntrega': enderecoEntrega.toJson(),
      'itens': itens.map((item) => item.toJson()).toList(),
      'pagamento': pagamento.map((parcela) => parcela.toJson()).toList(),
    };
  }
}
