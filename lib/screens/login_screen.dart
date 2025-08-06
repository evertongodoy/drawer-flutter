import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:drawer_flutter/env.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String? _erro;
  bool _carregando = false;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final documento = _documentoController.text.trim();
    final senha = _senhaController.text.trim();

    try {
      // Simula API (ex: await http.post)
      // await Future.delayed(const Duration(seconds: 2));

      final response = await http.post(
        Uri.parse('$baseUrl/banco-login/verifica'),  // $baseUrl -> import 'package:drawer_flutter/env.dart';
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'documento': documento,
          'senha': senha,
        }),
      );

      
      // if ((documento == '123' && senha == '123') ||
      //     (documento == '456' && senha == '456') ||
      //     (documento == '789' && senha == '789')) {
      //   Navigator.pushReplacementNamed(context, '/');
      // } else {
      //   throw Exception('Login inválido');
      // }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];

        if (status == 'OK') {
          // adicionado dependencia shared_preferences: ^2.0.15
          // Ao fazer login, salve o id do usuário (por exemplo em SharedPreferences)
          // salvar o ID no login e reaproveitar no app inteiro
          // import import 'package:shared_preferences/shared_preferences.dart';
          // para usar o SharedPreferences tambem precisou adicionar no SDK Manager / SDK Tools a propriedade NDK (Side by Side), show datails em baixo
          // precisou adicionar ndkVersion = "27.0.12077973"
          // no arquivo android/app/build.gradle
          // e executar os comandos:
          // flutter clean
          // flutter pub get
          // flutter run -d emulator-5554
          final id = data['id_usuario'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('usuarioId', id);  

          // Buscar conta se houver
          // 1. Buscar a(s) conta(s) do usuário
          final contaResponse = await http.get(
            Uri.parse('$baseUrl/banco-conta/listar-contas?idUsuario=$id'),
          );
          // 2. Verificar se a resposta é bem-sucedida
          if (contaResponse.statusCode == 200) {
            final contaData = jsonDecode(contaResponse.body);
            final contas = contaData['contas'];
            print('Contas: $contas');
            if (contas.isNotEmpty) {
              final conta = contas[0]; // pega a primeira conta do usuário
              final id = conta['id'];

              // 2. Salvar o idConta no SharedPreferences
              print('ID da conta: $id');
              await prefs.setInt('contaId', id);
            } 
          } else {
            await prefs.setInt('contaId', 0);
            print('Erro ao buscar contas: ${contaResponse.statusCode}');
          }

          // 3. verificar se a conta tem chave flux
          final chaveResponse = await http.get(
            Uri.parse('$baseUrl/banco-flux/buscar-flux/usuario/$id'),
          );
          if (chaveResponse.statusCode == 200) {
            final data = jsonDecode(chaveResponse.body); // <-- CORRETO
            final listaFlux = data['data'];
            if (listaFlux != null && listaFlux.isNotEmpty) {
              final chaveFlux = listaFlux[0]['chave_flux'];
              print('Chave Flux encontrada: $chaveFlux');
              // Armazenar no SharedPreferences
              await prefs.setString('chaveFlux', chaveFlux);
            }
          } else {
            print('Chave Flux não encontrada ou erro: ${chaveResponse.statusCode}');
            await prefs.setString('chaveFlux', '0');
          }



          // Login bem-sucedido → navega para a tela principal
          Navigator.pushReplacementNamed(context, '/');
        } else if (status == 'SENHA_NAO_CADASTRADA') {
          setState(() {
            _erro = 'Usuário precisa cadastrar uma senha';
          });
          // aqui você pode redirecionar para tela de cadastro de senha
        } else if (status == 'SENHA_INVALIDA') {
          setState(() {
            _erro = 'Senha incorreta';
          });
        } else if (status == 'NAO_CADASTRADO') {
          setState(() {
            _erro = 'Usuário não encontrado';
          });
        } else {
          setState(() {
            _erro = 'Erro inesperado: $status';
          });
        }
      } else {
        setState(() {
          _erro = 'Erro de servidor: ${response.statusCode}';
        });
      }

    } catch (e) {
      // setState(() {
      //   _erro = e.toString();
      // });
      setState(() {
        _erro = 'Erro na requisição: $e';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),
      automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _documentoController,
              decoration: const InputDecoration(labelText: 'Documento'),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_carregando)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
              ),
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _erro!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
      ),
    );
  }
}
