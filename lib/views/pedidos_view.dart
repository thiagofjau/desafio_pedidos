import 'package:desafio_pedidos/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pedido_controller.dart';
import '../models/pedido.dart';
import 'pedido_details_view.dart';

class PedidosView extends StatelessWidget {
  final PedidoController controller = Get.find<PedidoController>();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  PedidosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedidos')),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botão consultar e campo de pesquisa em linha
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.refresh, color: branco),
                    label: Text('Consultar', style: TextStyle(color: branco)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: verdeEscuro,
                    ),
                    onPressed:
                        () => controller.fetchPedidos(forceRefresh: true),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Pesquisar por cliente',
                        labelStyle: TextStyle(color: verdeEscuro),
                        suffixIcon: Icon(Icons.search, color: verdeEscuro),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: verdeEscuro),
                        ),
                      ),
                      onChanged: controller.searchPedidos,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Cabeçalho da tabela
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                color: verdeEscuro,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Nº',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: branco,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Data',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: branco,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Cliente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: branco,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: branco,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: branco,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: branco,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ), // Adiciona espaçamento extra no final do Row
                  ],
                ),
              ),

              // Lista de pedidos
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (controller.filteredPedidos.isEmpty) {
                    return Center(child: Text('Nenhum pedido encontrado'));
                  } else {
                    return ListView.builder(
                      itemCount: controller.filteredPedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = controller.filteredPedidos[index];
                        return InkWell(
                          onTap: () {
                            _showPedidoDetails(context, pedido);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  index % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    pedido.numero.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _formatDate(pedido.dataCriacao),
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    pedido.cliente.nome,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    pedido.status,
                                    style: TextStyle(
                                      color: _getStatusTextColor(pedido.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'R\$ ${pedido.valorTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(Icons.info_outline),
                                    tooltip: 'Detalhes',
                                    onPressed:
                                        () =>
                                            _showPedidoDetails(context, pedido),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ), // Adiciona espaçamento extra no final do Row
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funções auxiliares
  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString().substring(2)}';
    } catch (e) {
      return date;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'APROVADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      case 'PENDENTE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showPedidoDetails(BuildContext context, Pedido pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: PedidoDetailsView(pedido: pedido),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: verdeEscuro,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Fechar',
                  style: TextStyle(color: branco, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
