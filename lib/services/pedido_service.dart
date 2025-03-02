import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/pedido.dart';

class ApiService extends GetxService {
  final String apiUrl = 'https://desafiotecnicosti3.azurewebsites.net/pedido';

  // Função para obter todos os pedidos
  Future<List<Pedido>> fetchPedidos() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        return data.map((pedido) => Pedido.fromJson(pedido)).toList();
      } else {
        throw Exception('Falha ao carregar pedidos');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}
