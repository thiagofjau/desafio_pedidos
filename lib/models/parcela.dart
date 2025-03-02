import 'package:hive/hive.dart';

part 'parcela.g.dart';

@HiveType(typeId: 5)
class Parcela {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int parcela;

  @HiveField(2)
  final double valor;

  @HiveField(3)
  final String codigo;

  @HiveField(4)
  final String nome;

  Parcela({
    required this.id,
    required this.parcela,
    required this.valor,
    required this.codigo,
    required this.nome,
  });

  factory Parcela.fromJson(Map<String, dynamic> json) {
    return Parcela(
      id: json['id'] ?? '',
      parcela: json['parcela'] ?? 0,
      valor: (json['valor'] ?? 0).toDouble(),
      codigo: json['codigo'] ?? '',
      nome: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcela': parcela,
      'valor': valor,
      'codigo': codigo,
      'nome': nome,
    };
  }
}
