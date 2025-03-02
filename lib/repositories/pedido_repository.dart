import 'package:get/get.dart';
import '../models/pedido.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class PedidoRepository extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final HiveService hiveService = Get.find<HiveService>();

  // Busca pedidos priorizando o cache local e atualizando com API
  Future<List<Pedido>> getPedidos({bool forceRefresh = false}) async {
    try {
      // Se não forçar refresh, tenta buscar do cache primeiro
      if (!forceRefresh) {
        final localPedidos = await hiveService.getAllPedidos();
        if (localPedidos.isNotEmpty) {
          return localPedidos;
        }
      }

      // Busca da API
      final remotePedidos = await apiService.fetchPedidos();

      // Salva no cache local
      await hiveService.savePedidos(remotePedidos);
      print('PedidoRepository: Dados salvos no Hive');

      // Verificar dados salvos no Hive
      await hiveService.printAllPedidos();

      return remotePedidos;
    } catch (e) {
      // Em caso de erro na API, tenta retornar dados locais
      try {
        return await hiveService.getAllPedidos();
      } catch (e) {
        throw Exception('Falha ao obter pedidos: $e');
      }
    }
  }

  // Buscar pedidos por nome do cliente
  Future<List<Pedido>> searchPedidosByClientName(String query) async {
    return await hiveService.searchPedidosByClientName(query);
  }

  // Buscar um pedido específico
  Future<Pedido?> getPedidoById(String id, {bool forceRefresh = false}) async {
    try {
      // Se não forçar refresh, tenta buscar do cache primeiro
      if (!forceRefresh) {
        final localPedido = await hiveService.getPedidoById(id);
        if (localPedido != null) {
          return localPedido;
        }
      }

      // Busca da API
      final remotePedido = await apiService.fetchPedidoById(id);

      // Salva no cache local
      await hiveService.savePedido(remotePedido);
      print('PedidoRepository: Pedido salvo no Hive');

      // Verificar dados salvos no Hive
      await hiveService.printAllPedidos();

      return remotePedido;
    } catch (e) {
      // Em caso de erro na API, tenta retornar dados locais
      return await hiveService.getPedidoById(id);
    }
  }

  // Limpar cache local
  Future<void> clearCache() async {
    await hiveService.clearAllPedidos();
  }

  // MÉTODOS PARA RELATÓRIOS

  // Produtos mais vendidos
  Future<List<Map<String, dynamic>>> getMostSoldProducts() async {
    final pedidos = await hiveService.getAllPedidos();

    // Mapear por produto
    final productMap = <String, Map<String, dynamic>>{};

    for (final pedido in pedidos) {
      if (pedido.status == 'APROVADO') {
        for (final item in pedido.itens) {
          if (productMap.containsKey(item.idProduto)) {
            productMap[item.idProduto]!['quantidade'] += item.quantidade;
            productMap[item.idProduto]!['totalValor'] +=
                item.valorUnitario * item.quantidade;
            productMap[item.idProduto]!['ocorrencias'] += 1;
          } else {
            productMap[item.idProduto] = {
              'produto': item.nome,
              'quantidade': item.quantidade,
              'totalValor': item.valorUnitario * item.quantidade,
              'ocorrencias': 1,
            };
          }
        }
      }
    }

    // Transformar em lista e calcular valor médio
    final result =
        productMap.values.map((product) {
          return {
            'produto': product['produto'],
            'quantidade': product['quantidade'],
            'valorMedio': product['totalValor'] / product['quantidade'],
          };
        }).toList();

    // Ordenar por quantidade vendida (decrescente)
    result.sort(
      (a, b) => (b['quantidade'] as int).compareTo(a['quantidade'] as int),
    );

    return result;
  }

  // Totalização de Formas de Pagamento por Dia
  Future<List<Map<String, dynamic>>> getPaymentMethodsByDay() async {
    final pedidos = await hiveService.getAllPedidos();

    // Agrupar por data+formaPagamento
    final paymentByDay = <String, Map<String, dynamic>>{};

    for (final pedido in pedidos) {
      if (pedido.status == 'APROVADO') {
        // Pegar apenas a data (sem hora)
        final date = pedido.dataCriacao.split('T')[0];

        for (final pagamento in pedido.pagamento) {
          final key = '$date-${pagamento.nome}';

          if (paymentByDay.containsKey(key)) {
            paymentByDay[key]!['valor'] += pagamento.valor;
          } else {
            paymentByDay[key] = {
              'data': date,
              'formaPagamento': pagamento.nome,
              'valor': pagamento.valor,
            };
          }
        }
      }
    }

    final result = paymentByDay.values.toList();

    // Ordenar por data
    result.sort((a, b) => (a['data'] as String).compareTo(b['data'] as String));

    return result;
  }

  // Totalização de Vendas por Cidade
  Future<List<Map<String, dynamic>>> getSalesByCity() async {
    final pedidos = await hiveService.getAllPedidos();

    // Agrupar por cidade
    final salesByCity = <String, Map<String, dynamic>>{};

    for (final pedido in pedidos) {
      if (pedido.status == 'APROVADO') {
        final cidade = pedido.enderecoEntrega.cidade;

        if (salesByCity.containsKey(cidade)) {
          salesByCity[cidade]!['quantidade'] += 1;
          salesByCity[cidade]!['valorTotal'] += pedido.valorTotal;
        } else {
          salesByCity[cidade] = {
            'cidade': cidade,
            'quantidade': 1,
            'valorTotal': pedido.valorTotal,
          };
        }
      }
    }

    final result = salesByCity.values.toList();

    // Ordenar por valor total (decrescente)
    result.sort(
      (a, b) =>
          (b['valorTotal'] as double).compareTo(a['valorTotal'] as double),
    );

    return result;
  }

  // Totalização de Vendas por Faixa Etária
  Future<List<Map<String, dynamic>>> getSalesByAgeRange() async {
    final pedidos = await hiveService.getAllPedidos();

    // Agrupar por faixa etária
    final ageRanges = {
      'Até 18 anos': {'quantidade': 0, 'valorTotal': 0.0},
      '19 a 25 anos': {'quantidade': 0, 'valorTotal': 0.0},
      '26 a 35 anos': {'quantidade': 0, 'valorTotal': 0.0},
      '36 a 50 anos': {'quantidade': 0, 'valorTotal': 0.0},
      'Acima de 50 anos': {'quantidade': 0, 'valorTotal': 0.0},
    };

    final now = DateTime.now();

    for (final pedido in pedidos) {
      if (pedido.status == 'APROVADO') {
        try {
          // Calcular idade
          final birthDate = DateTime.parse(
            pedido.cliente.dataNascimento.split('+')[0],
          );
          final age =
              now.year -
              birthDate.year -
              ((now.month > birthDate.month ||
                      (now.month == birthDate.month &&
                          now.day >= birthDate.day))
                  ? 0
                  : 1);

          String ageRange;
          if (age <= 18) {
            ageRange = 'Até 18 anos';
          } else if (age <= 25) {
            ageRange = '19 a 25 anos';
          } else if (age <= 35) {
            ageRange = '26 a 35 anos';
          } else if (age <= 50) {
            ageRange = '36 a 50 anos';
          } else {
            ageRange = 'Acima de 50 anos';
          }

          ageRanges[ageRange]!['quantidade'] =
              (ageRanges[ageRange]!['quantidade'] as int) + 1;
          ageRanges[ageRange]!['valorTotal'] =
              (ageRanges[ageRange]!['valorTotal'] as double) +
              pedido.valorTotal;
        } catch (e) {
          // Ignore errors in date parsing
          print('Erro ao processar data de nascimento: $e');
        }
      }
    }

    // Transform into result list
    final result =
        ageRanges.entries
            .map(
              (entry) => {
                'faixaEtaria': entry.key,
                'quantidade': entry.value['quantidade'],
                'valorTotal': entry.value['valorTotal'],
              },
            )
            .toList();

    return result;
  }
}