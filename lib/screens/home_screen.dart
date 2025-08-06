import 'dart:convert';

import 'package:drawer_flutter/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drawer_flutter/env.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Usuario>? _usuarioFuture;

  Future<Usuario> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('usuarioId');

    if (id == null) throw Exception("ID do usuário não encontrado");

    final response = await http.get(
      Uri.parse(
        '$baseUrl/banco-usuario/buscar-usuario/usuario?id=$id', // $baseUrl -> import 'package:drawer_flutter/env.dart';
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'];
      final usuario = data[0][0]; // pois vem uma lista dentro de uma lista
      return Usuario.fromJson(usuario);
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }

  @override
  void initState() {
    super.initState();
    _usuarioFuture = _carregarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Financeiro')),
      drawer: Drawer(
        child: ListView(
          children: [
            // removido const  para pegar p nome da pessoa logada
            DrawerHeader(
              padding: EdgeInsetsGeometry.all(30),
              decoration: BoxDecoration(color: Colors.indigo),
              child: FutureBuilder<Usuario>(
                future: _usuarioFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Erro ao carregar',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    final usuario = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Banco Senac',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          usuario.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      'Usuário não encontrado',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
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
              title: const Text('Transferência Flux'),
              onTap: () {
                Navigator.pushNamed(context, '/transferencia');
              },
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Chave Flux'),
              // onTap: () {
              //   Navigator.pushNamed(context, '/chave-transferencia');
              // },
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final idUsuario = prefs.getInt('usuarioId');

                if (idUsuario == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuário não logado')),
                  );
                  return;
                }

                final url = Uri.parse('$baseUrl/banco-flux/check-existencia-flux/usuario/$idUsuario');
                final response = await http.get(url);

                if (response.statusCode == 200) {
                  final json = jsonDecode(response.body);
                  final existe = json['data'][0] == true;

                  if (existe) {
                    Navigator.pushNamed(context, '/chave-existente'); // nova rota que exibe a chave
                  } else {
                    Navigator.pushNamed(context, '/chave-cadastrar'); // nova rota com botão para cadastrar
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erro ao verificar chave')),
                  );
                }
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

      body: FutureBuilder<Usuario>(
        future: _usuarioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final usuario = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Olá, ${usuario.nome}!',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Bem vindo(a) ao banco!',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Usuário não encontrado'));
          }
        },
      ),
    );
  }
}
