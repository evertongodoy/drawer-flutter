import 'package:drawer_flutter/screens/chave_cadastrar_screen.dart';
import 'package:drawer_flutter/screens/chave_existe_screen.dart';
import 'package:drawer_flutter/screens/chave_transferencia_screen.dart';
import 'package:drawer_flutter/screens/extrato_screen.dart';
import 'package:drawer_flutter/screens/home_screen.dart';
import 'package:drawer_flutter/screens/carteira_screen.dart';
import 'package:drawer_flutter/screens/login_screen.dart';
import 'package:drawer_flutter/screens/transferencia_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



// void main() {
Future<void> main() async {  
  // WidgetsFlutterBinding.ensureInitialized(); // precisou colocar essa linha porque nao carregava a aplicacao e tambem precisou colocar o - .env dentro de assets no pubspec.yaml
  await dotenv.load(fileName: ".env");
  runApp(const BancoApp());
}

class BancoApp extends StatelessWidget {
  const BancoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senac Financeiro App',
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      // home: const HomeScreen(),
      initialRoute: '/login',
      // debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomeScreen(),
        '/chave-cadastrar': (context) => const ChaveCadastrarScreen(),
        '/chave-existente': (context) => const ChaveExisteScreen(),
        '/login': (context) => const LoginScreen(),
        '/carteira': (context) => const CarteiraScreen(),
        '/extrato': (context) => const ExtratoScreen(),
        '/transferencia': (context) => const Transferencia(),
        '/chave-transferencia': (context) => const ChaveTransferencia(),
      },
    );
  }
}
