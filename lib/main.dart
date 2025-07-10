import 'package:drawer_flutter/screens/chave_transferencia_screen.dart';
import 'package:drawer_flutter/screens/extrato_screen.dart';
import 'package:drawer_flutter/screens/home_screen.dart';
import 'package:drawer_flutter/screens/carteira_screen.dart';
import 'package:drawer_flutter/screens/login_screen.dart';
import 'package:drawer_flutter/screens/transferencia_screen.dart';

import 'package:flutter/material.dart';


void main() {
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
      routes: {
        '/': (context) => const HomeScreen(),  
        '/login': (context) => const LoginScreen(),
        '/carteira': (context) => const CarteiraScreen(),
        '/extrato': (context) => const ExtratoScreen(),
        '/transferencia': (context) => const Transferencia(),
        '/chave-transferencia': (context) => const ChaveTransferencia(),
      },
    );
  }
}
