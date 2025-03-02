import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 4)
class Item {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String idProduto;

  @HiveField(2)
  final String nome;

  @HiveField(3)
  final int quantidade;

  @HiveField(4)
  final double valorUnitario;

  Item({
    required this.id,
    required this.idProduto,
    required this.nome,
    required this.quantidade,
    required this.valorUnitario,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? '',
      idProduto: json['idProduto'] ?? '',
      nome: json['nome'] ?? '',
      quantidade: json['quantidade'] ?? 0,
      valorUnitario: (json['valorUnitario'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProduto': idProduto,
      'nome': nome,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
    };
  }

  // Calcular o preço total
  double get valorTotal => quantidade * valorUnitario;
}
