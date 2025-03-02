import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pedido.dart';

class PedidoDetailsView extends StatelessWidget {
  final Pedido pedido;

  const PedidoDetailsView({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(1),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalhes do Pedido #${pedido.numero}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildProductsTable(),
                SizedBox(height: 8),
                _buildSummary(),
                SizedBox(height: 8),
                _buildPaymentsTable(),
                SizedBox(height: 8),
                _buildCustomerInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsTable() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produtos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        ...pedido.itens.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(
                  '${item.quantidade} x ${currencyFormatter.format(item.valorUnitario)}',
                ),
                Text(
                  'Subtotal: ${currencyFormatter.format(item.quantidade * item.valorUnitario)}',
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummary() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        _buildSummaryRow(
          'Subtotal:',
          currencyFormatter.format(pedido.subTotal),
        ),
        _buildSummaryRow('Frete:', currencyFormatter.format(pedido.frete)),
        _buildSummaryRow(
          'Desconto:',
          '- ${currencyFormatter.format(pedido.desconto)}',
        ),
        SizedBox(height: 8),
        _buildSummaryRow(
          'Total:',
          currencyFormatter.format(pedido.valorTotal),
          valueStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: valueStyle ?? TextStyle()),
        ],
      ),
    );
  }

  Widget _buildPaymentsTable() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pagamentos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        ...pedido.pagamento.map((parcela) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Nº de Parcela:', parcela.parcela.toString()),
                _buildInfoRow(
                  'Valor:',
                  currencyFormatter.format(parcela.valor),
                ),
                _buildInfoRow('Forma:', parcela.nome),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações do Cliente',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        _buildInfoRow('Cliente:', pedido.cliente.nome),
        _buildInfoRow('CPF:', pedido.cliente.cpf),
        _buildInfoRow('Email:', pedido.cliente.email),
        SizedBox(height: 8),
        Text(
          'Endereço de Entrega',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Divider(),
        _buildInfoRow(
          'Endereço:',
          '${pedido.enderecoEntrega.endereco}, ${pedido.enderecoEntrega.numero}',
        ),
        _buildInfoRow(
          'Cidade:',
          '${pedido.enderecoEntrega.cidade} - ${pedido.enderecoEntrega.estado}',
        ),
        _buildInfoRow('CEP:', pedido.enderecoEntrega.cep),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
