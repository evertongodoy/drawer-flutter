import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String? _erro;
  bool _carregando = false;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    try {
      // Simula API (ex: await http.post)
      await Future.delayed(const Duration(seconds: 2));
      
      if ((usuario == 'joao' && senha == '123') ||
          (usuario == 'maria' && senha == '456') ||
          (usuario == 'pedro' && senha == '789')) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        throw Exception('Usuário ou senha inválidos');
      }
    } catch (e) {
      setState(() {
        _erro = e.toString();
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuário'),
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
