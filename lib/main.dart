import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'views/home_view.dart';
import 'services/api_service.dart';
import 'services/hive_service.dart';
import 'repositories/pedido_repository.dart';
import 'controllers/pedido_controller.dart';
import 'models/pedido.dart';
import 'models/cliente.dart';
import 'models/endereco.dart';
import 'models/item.dart';
import 'models/parcela.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Registrar adaptadores
  Hive.registerAdapter(PedidoAdapter());
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(EnderecoAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(ParcelaAdapter());

  // Registrar dependências no GetX
  Get.put(ApiService());
  Get.put(HiveService());
  Get.put(PedidoRepository());
  Get.put(PedidoController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aplicativo de Pedidos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
