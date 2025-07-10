import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'Nosso aplicativo',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Cadastro da Pessoa'),
            onTap: () {
              // Ação ao tocar no item Home
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Center(
                    child: Text(
                      'Tela de Cadastro da Pessoa',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ); // Fecha o drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Lista de Desejos'),
            onTap: () {
              // Ação ao tocar no item Lista de Desejos
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Center(
                    child: Text(
                      'Tela de Lista de Desejos',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ); // Fecha o drawer
            },
          ),
        ],
      ),
    );
  }
}
