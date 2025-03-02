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
        throw Exception('Falha ao carregar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  // Buscar um pedido específico pelo ID
  Future<Pedido> fetchPedidoById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Pedido.fromJson(data);
      } else {
        throw Exception('Falha ao carregar o pedido: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
