import 'package:desafio_pedidos/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pedido_controller.dart';

class RelatoriosView extends StatefulWidget {
  const RelatoriosView({super.key});

  @override
  _RelatoriosViewState createState() => _RelatoriosViewState();
}

class _RelatoriosViewState extends State<RelatoriosView> {
  final PedidoController controller = Get.find<PedidoController>();
  final List<String> tiposRelatorio = [
    'Produtos mais vendidos',
    'Formas de pagamento por dia',
    'Vendas por cidade',
    'Vendas por faixa etária',
  ];

  String? tipoSelecionado;
  var dadosRelatorio = <Map<String, dynamic>>[];
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Relatórios')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de Relatório',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: verdeEscuro,
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButton<String>(
                      hint: Text('Selecione o tipo de relatório'),
                      isExpanded: true,
                      value: tipoSelecionado,
                      items:
                          tiposRelatorio.map((tipo) {
                            return DropdownMenuItem<String>(
                              value: tipo,
                              child: Text(tipo),
                            );
                          }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          tipoSelecionado = value;
                          isLoading = true;
                          errorMessage = null;
                        });

                        try {
                          await _carregarDadosRelatorio();
                        } catch (e) {
                          setState(() {
                            errorMessage = 'Erro ao carregar dados: $e';
                          });
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(child: _buildRelatorioBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatorioBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
      );
    }

    if (tipoSelecionado == null) {
      return Center(child: Text('Selecione um tipo de relatório'));
    }

    if (dadosRelatorio.isEmpty) {
      return Center(child: Text('Nenhum dado disponível para este relatório'));
    }

    switch (tipoSelecionado) {
      case 'Produtos mais vendidos':
        return _buildProdutosMaisVendidosTable();
      case 'Formas de pagamento por dia':
        return _buildFormasPagamentoPorDiaTable();
      case 'Vendas por cidade':
        return _buildVendasPorCidadeTable();
      case 'Vendas por faixa etária':
        return _buildVendasPorFaixaEtariaTable();
      default:
        return Center(child: Text('Relatório não implementado'));
    }
  }

  Widget _buildProdutosMaisVendidosTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Produtos Mais Vendidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: verdeEscuro,
              ),
            ),
          ),
          Divider(height: 0),
          _tableHeader(['Produto', 'Qtde.', 'Valor Médio'], [4, 2, 3]),
          Expanded(
            child: ListView.builder(
              itemCount: dadosRelatorio.length,
              itemBuilder: (context, index) {
                final item = dadosRelatorio[index];
                return _tableRow(
                  [
                    item['produto'].toString(),
                    item['quantidade'].toString(),
                    'R\$ ${(item['valorMedio'] as double).toStringAsFixed(2)}',
                  ],
                  [4, 2, 3],
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormasPagamentoPorDiaTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Formas de Pagamento por Dia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 0),
          _tableHeader(['Data', 'Forma de Pagamento', 'Valor'], [3, 4, 2]),
          Expanded(
            child: ListView.builder(
              itemCount: dadosRelatorio.length,
              itemBuilder: (context, index) {
                final item = dadosRelatorio[index];
                return _tableRow(
                  [
                    _formatDate(item['data'].toString()),
                    item['formaPagamento'].toString(),
                    'R\$ ${(item['valor'] as double).toStringAsFixed(2)}',
                  ],
                  [3, 4, 2],
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendasPorCidadeTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Vendas por Cidade',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 0),
          _tableHeader(['Cidade', 'Qtde de Pedidos', 'Valor Total'], [4, 3, 2]),
          Expanded(
            child: ListView.builder(
              itemCount: dadosRelatorio.length,
              itemBuilder: (context, index) {
                final item = dadosRelatorio[index];
                return _tableRow(
                  [
                    item['cidade'].toString(),
                    item['quantidade'].toString(),
                    'R\$ ${(item['valorTotal'] as double).toStringAsFixed(2)}',
                  ],
                  [4, 3, 2],
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendasPorFaixaEtariaTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Vendas por Faixa Etária',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 0),
          _tableHeader(
            ['Faixa Etária', 'Qtde de Pedidos', 'Valor Total'],
            [4, 3, 2],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dadosRelatorio.length,
              itemBuilder: (context, index) {
                final item = dadosRelatorio[index];
                return _tableRow(
                  [
                    item['faixaEtaria'].toString(),
                    item['quantidade'].toString(),
                    'R\$ ${(item['valorTotal'] as double).toStringAsFixed(2)}',
                  ],
                  [4, 3, 2],
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(List<String> titles, List<int> flexValues) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: verdeEscuro,
      child: Row(
        children: List.generate(
          titles.length,
          (index) => Expanded(
            flex: flexValues[index],
            child: Text(
              titles[index],
              style: TextStyle(fontWeight: FontWeight.w500, color: branco),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _carregarDadosRelatorio() async {
    try {
      switch (tipoSelecionado) {
        case 'Produtos mais vendidos':
          dadosRelatorio = await controller.getMostSoldProducts();
          break;
        case 'Formas de pagamento por dia':
          dadosRelatorio = await controller.getPaymentMethodsByDay();
          break;
        case 'Vendas por cidade':
          dadosRelatorio = await controller.getSalesByCity();
          break;
        case 'Vendas por faixa etária':
          dadosRelatorio = await controller.getSalesByAgeRange();
          break;
        default:
          dadosRelatorio = [];
          break;
      }
    } catch (e) {
      throw Exception('Erro ao carregar dados do relatório: $e');
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _tableRow(List<String> values, List<int> flexValues, int index) {
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: List.generate(
          values.length,
          (index) => Expanded(
            flex: flexValues[index],
            child: Text(
              values[index],
              style: index == 0 ? TextStyle(fontWeight: FontWeight.w500) : null,
            ),
          ),
        ),
      ),
    );
  }
}
