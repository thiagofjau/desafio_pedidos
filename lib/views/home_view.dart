import 'package:desafio_pedidos/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pedidos_view.dart';
import 'relatorios_view.dart';
import '../controllers/pedido_controller.dart';

class HomeView extends StatelessWidget {
  final PedidoController controller = Get.find<PedidoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desafio STi3')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: verdeEscuro, 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Text('Menu', style: TextStyle(color: branco, fontSize: 20)),
                  SizedBox(height: 10),
                  Text(
                    'Consultas',
                    style: TextStyle(color: branco, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: preto),
              title: Text('Pedidos'),
              onTap: () {
                // Fecha o drawer e navega para a tela de pedidos
                Navigator.pop(context);
                Get.to(() => PedidosView());
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Relatórios'),
              onTap: () {
                // Fecha o drawer e navega para a tela de relatórios
                Navigator.pop(context);
                Get.to(() => RelatoriosView());
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.sti3.com.br/wp-content/uploads/2021/04/cropped-sti3-logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Bem-vindo à Consulta de Pedidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Selecione uma opção no menu lateral para começar',
              style: TextStyle(fontSize: 14, color: cinzaEscuro),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.shopping_cart, color: branco),
              label: Text('Ir para Pedidos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeEscuro,
                foregroundColor: branco,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                Get.to(() => PedidosView());
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.bar_chart, color: branco),
              label: Text('Ir para Relatórios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeEscuro,
                foregroundColor: branco,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                Get.to(() => RelatoriosView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
