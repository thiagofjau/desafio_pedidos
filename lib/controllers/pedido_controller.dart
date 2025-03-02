import 'package:get/get.dart';

//ESTE ESTAVA FUNCIONANDO CERTINHO SO FALTOU O SALVA NO HIVE
import '../models/pedido.dart';
import '../repositories/pedido_repository.dart';

class PedidoController extends GetxController {
  final PedidoRepository repository = Get.find<PedidoRepository>();

  var pedidos = <Pedido>[].obs;
  var filteredPedidos = <Pedido>[].obs;
  var selectedPedido = Rx<Pedido?>(null);
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPedidos();

    // Configurar reação para busca
    ever(searchQuery, (_) => _filterPedidos());
  }

  // Filtrar pedidos com base na busca
  void _filterPedidos() async {
    if (searchQuery.value.isEmpty) {
      filteredPedidos.value = pedidos;
    } else {
      filteredPedidos.value = await repository.searchPedidosByClientName(
        searchQuery.value,
      );
    }
  }

  // Buscar pedidos usando o repositório
  Future<void> fetchPedidos({bool forceRefresh = false}) async {
    try {
      isLoading(true);
      errorMessage('');

      var fetchedPedidos = await repository.getPedidos(
        forceRefresh: forceRefresh,
      );
      pedidos.value = fetchedPedidos;
      filteredPedidos.value = fetchedPedidos;
    } catch (e) {
      errorMessage('Erro ao buscar pedidos: $e');
      print('Erro ao buscar pedidos: $e');
    } finally {
      isLoading(false);
    }
  }

  // Selecionar um pedido
  void selectPedido(Pedido pedido) {
    selectedPedido.value = pedido;
  }

  // Limpar seleção
  void clearSelection() {
    selectedPedido.value = null;
  }

  // Buscar pedidos por nome do cliente
  void searchPedidos(String query) {
    searchQuery.value = query;
  }

  // Obter um pedido específico pelo ID
  Future<Pedido?> getPedidoById(String id, {bool forceRefresh = false}) async {
    try {
      return await repository.getPedidoById(id, forceRefresh: forceRefresh);
    } catch (e) {
      errorMessage('Erro ao buscar pedido: $e');
      print('Erro ao buscar pedido: $e');
      return null;
    }
  }

  // Limpar cache
  Future<void> clearCache() async {
    try {
      await repository.clearCache();
      await fetchPedidos(forceRefresh: true);
    } catch (e) {
      errorMessage('Erro ao limpar cache: $e');
      print('Erro ao limpar cache: $e');
    }
  }

  // MÉTODOS PARA RELATÓRIOS

  // Obter produtos mais vendidos
  Future<List<Map<String, dynamic>>> getMostSoldProducts() {
    return repository.getMostSoldProducts();
  }

  // Obter formas de pagamento por dia
  Future<List<Map<String, dynamic>>> getPaymentMethodsByDay() {
    return repository.getPaymentMethodsByDay();
  }

  // Obter vendas por cidade
  Future<List<Map<String, dynamic>>> getSalesByCity() {
    return repository.getSalesByCity();
  }

  // Obter vendas por faixa etária
  Future<List<Map<String, dynamic>>> getSalesByAgeRange() {
    return repository.getSalesByAgeRange();
  }
}
