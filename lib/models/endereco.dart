import 'package:hive/hive.dart';

part 'endereco.g.dart';

@HiveType(typeId: 3)
class Endereco {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String endereco;

  @HiveField(2)
  final String numero;

  @HiveField(3)
  final String cep;

  @HiveField(4)
  final String bairro;

  @HiveField(5)
  final String cidade;

  @HiveField(6)
  final String estado;

  @HiveField(7)
  final String complemento;

  @HiveField(8)
  final String referencia;

  Endereco({
    required this.id,
    required this.endereco,
    required this.numero,
    required this.cep,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.complemento,
    required this.referencia,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      id: json['id'] ?? '',
      endereco: json['endereco'] ?? '',
      numero: json['numero'] ?? '',
      cep: json['cep'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      estado: json['estado'] ?? '',
      complemento: json['complemento'] ?? '',
      referencia: json['referencia'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endereco': endereco,
      'numero': numero,
      'cep': cep,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
      'referencia': referencia,
    };
  }
}
