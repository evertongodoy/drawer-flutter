import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drawer_flutter/env.dart';
import 'package:http/http.dart' as http;

class ChaveCadastrarScreen extends StatelessWidget {
  const ChaveCadastrarScreen({super.key});

  Future<void> _cadastrarChave(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance(); // import 'package:shared_preferences/shared_preferences.dart';
    final idUsuario = prefs.getInt('usuarioId');

    if(idUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado')),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/banco-flux/criar-flux/usuario/$idUsuario'); // import 'package:drawer_flutter/env.dart';
    
    try {
      final response = await http.post(url); // import 'package:http/http.dart' as http;
      if (response.statusCode == 200) {
        // Cadastro bem-sucedido → redireciona para tela que exibe a chave
        Navigator.pushReplacementNamed(context, '/chave-existente');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${response.statusCode} ao cadastrar chave')),
        );
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar com o servidor: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Chave Flux')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Cadastre sua chave Flux', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _cadastrarChave(context),
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}