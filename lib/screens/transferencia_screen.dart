import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drawer_flutter/env.dart';


class Transferencia extends StatefulWidget{
  const Transferencia({super.key});

  @override
  State<Transferencia> createState() => _TransferenciaState();
}

class _TransferenciaState extends State<Transferencia> {
  final TextEditingController _chaveController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _confirmarTransferencia(BuildContext context) {
    FocusScope.of(context).unfocus(); // <--  remover o foco antes de executar a lógica, Isso força o Flutter a remover o foco dos campos ativos (como o TextField) e garante que o valor mais recente esteja refletido no .text.
    final chave = _chaveController.text.trim();
    final valor = _valorController.text.trim();
    

    if (chave.isEmpty || valor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha a chave e o valor',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

 

    // SALVA O CONTEXTO ANTES DO showDialog
    final parentContext = context;

    showDialog(
      // context: context,
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Transferência'),
          content: Text('Deseja transferir R\$ $valor para a chave: $chave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async { // adicionado async para fazer request na URL da transferencia para usar com o await
                Navigator.of(context).pop(); // Fecha o dialogo
                try {
                  final prefs = await SharedPreferences.getInstance(); // import 'package:shared_preferences/shared_preferences.dart';
                  final idUsuario = prefs.getInt('usuarioId');
                  final minhaChaveFlux = prefs.getString('chaveFlux');
                  final chaveDestino = _chaveController.text.trim();
                  final valor = _valorController.text.trim();

                  if (idUsuario == null) {
                    throw Exception("Usuário não está logado.");
                  }

                  if (minhaChaveFlux == null) {
                        throw Exception("Chave Flux não encontrada.");
                  }
                  if (minhaChaveFlux == chaveDestino) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Você não pode transferir para sua própria chave Flux.',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 0, 0),
                      ),
                    );
                    return;
                  }
                      
                  final url = Uri.parse('$baseUrl/banco-transferencia/transferir-flux-to'); // base urlimport 'package:drawer_flutter/env.dart';
                  final response = await http.post(
                    url, 
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      "flux_to": chave,
                      "valor": double.parse(valor),
                      "id_usuario_from": idUsuario
                    }),
                  );

                  if (response.statusCode == 200) {
                    if (!mounted) return; // <-- aqui verifica se ainda está na tela
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Transferência realizada!!',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 1500));
                    if (!mounted) return;
                    Navigator.of(parentContext).pushReplacementNamed('/carteira');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Erro ao transferir: ${response.statusCode}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erro: ${e.toString()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                // // await http.post(Uri.parse('$baseUrl/banco-flux/transferir'), body: { 'chave': chave, ... });
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Transferência realizada!!!!', 
                //     style: TextStyle(fontSize: 20, color: Colors.white),
                //     textAlign: TextAlign.center),
                //   ),
                // );
              },
              child: const Text('Confirma ?'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _chaveController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transferência')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Transferência via Chave Flux',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _chaveController,
                decoration: const InputDecoration(
                  labelText: 'Chave Flux',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromARGB(255, 254, 190, 190),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  //   },
                  //   child: const Text('Cancelar'),
                  // ),
                  ElevatedButton(
                    onPressed: () => _confirmarTransferencia(context),
                    child: const Text('Transferir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
class Transferencia extends StatelessWidget{
  const Transferencia({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferência'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tela de Transferência Bancária',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Voltar para a tela inicial
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

}
*/