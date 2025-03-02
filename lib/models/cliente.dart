library desafio_pedidos.models.cliente;

import 'package:hive/hive.dart';

part 'cliente.g.dart';

@HiveType(typeId: 2)
class Cliente {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cnpj;

  @HiveField(2)
  final String cpf;

  @HiveField(3)
  final String nome;

  @HiveField(4)
  final String razaoSocial;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String dataNascimento;

  Cliente({
    required this.id,
    required this.cnpj,
    required this.cpf,
    required this.nome,
    required this.razaoSocial,
    required this.email,
    required this.dataNascimento,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? '',
      cnpj: json['cnpj'] ?? '',
      cpf: json['cpf'] ?? '',
      nome: json['nome'] ?? '',
      razaoSocial: json['razaoSocial'] ?? '',
      email: json['email'] ?? '',
      dataNascimento: json['dataNascimento'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnpj': cnpj,
      'cpf': cpf,
      'nome': nome,
      'razaoSocial': razaoSocial,
      'email': email,
      'dataNascimento': dataNascimento,
    };
  }
}
