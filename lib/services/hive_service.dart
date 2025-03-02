import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/pedido.dart';

class HiveService extends GetxService {
  static const String PEDIDOS_BOX = 'pedidos';

  Future<Box<Pedido>> openPedidosBox() async {
    return await Hive.openBox<Pedido>(PEDIDOS_BOX);
  }

  Future<void> savePedidos(List<Pedido> pedidos) async {
    final box = await openPedidosBox();

    // Limpar box e salvar novos pedidos
    await box.clear();

    // Usar transações para melhorar performance em múltiplos acessos
    await box.putAll({for (var pedido in pedidos) pedido.id: pedido});
    print('HiveService: Pedidos salvos no Hive');
  }

  Future<void> savePedido(Pedido pedido) async {
    final box = await openPedidosBox();
    await box.put(pedido.id, pedido);
    print('HiveService: Pedido salvo no Hive');
  }

  Future<List<Pedido>> getAllPedidos() async {
    final box = await openPedidosBox();
    return box.values.toList();
  }

  Future<Pedido?> getPedidoById(String id) async {
    final box = await openPedidosBox();
    return box.get(id);
  }

  Future<List<Pedido>> searchPedidosByClientName(String query) async {
    if (query.isEmpty) {
      return getAllPedidos();
    }

    final box = await openPedidosBox();
    final allPedidos = box.values.toList();

    return allPedidos
        .where(
          (pedido) =>
              pedido.cliente.nome.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> deletePedido(String id) async {
    final box = await openPedidosBox();
    await box.delete(id);
  }

  Future<void> clearAllPedidos() async {
    final box = await openPedidosBox();
    await box.clear();
  }

  // Método para imprimir os dados do Hive no console
  Future<void> printAllPedidos() async {
    final box = await openPedidosBox();
    final pedidos = box.values.toList();
    print('HiveService: Pedidos no Hive: $pedidos');
  }
}