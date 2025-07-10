import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Financeiro'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              padding: EdgeInsetsGeometry.all(50),
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Banco Senac',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),

            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Carteira'),
              onTap: () {
                Navigator.pushNamed(context, '/carteira');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Extrato'),
              onTap: () {
                Navigator.pushNamed(context, '/extrato');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Transferência'),
              onTap: () {
                Navigator.pushNamed(context, '/transferencia');
              },
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Chave de Transferência'),
              onTap: () {
                Navigator.pushNamed(context, '/chave-transferencia');
              },
            ),
            const Divider(), // linha separadora
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Depois troca toda a pilha para o login
                Navigator.pushNamed(context, '/login');
                // Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Bem vindo ao seu banco!')),
    );
  }
}
