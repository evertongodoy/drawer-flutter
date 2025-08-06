import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drawer_flutter/env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';


class ChaveExisteScreen extends StatefulWidget {
  const ChaveExisteScreen({super.key});

  @override
  State<ChaveExisteScreen> createState() => _ChaveExisteScreenState();
}

class _ChaveExisteScreenState extends State<ChaveExisteScreen> {
  String _chave = ''; // Simulação de chave
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarChaveFlux();
  }

  Future<void> _buscarChaveFlux() async {
    try {
      final prefs = await SharedPreferences.getInstance(); // import 'package:shared_preferences/shared_preferences.dart';
      final idUsuario = prefs.getInt('usuarioId');

      if (idUsuario == null) {
        throw Exception('Usuário não encontrado');
      }

      final url = Uri.parse('$baseUrl/banco-flux/buscar-flux/usuario/$idUsuario'); // import 'package:drawer_flutter/env.dart';
      final response = await http.get(url); // import 'package:http/http.dart' as http;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body); // import 'dart:convert';
        final data = json['data'];
        final flux = data[0];

        setState(() {
          _chave = flux['chave_flux'];
          _carregando = false;
        });
      } else {
        throw Exception('Erro ao buscar chave: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _chave = '';
        _carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Chave Flux')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sua chave Flux:\n$_chave',
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copiar Chave'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _chave)); // import 'package:flutter/services.dart';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chave copiada para \n a área de transferência',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),


      /*
        Center(
        child: _carregando
            ? const CircularProgressIndicator()
            : _chave != ''
                ? Text(
                    'Sua chave Flux:\n$_chave',
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    'Chave não encontrada.',
                    style: TextStyle(fontSize: 20),
                  ),
      ),
      */
    );
  }
}

// class ChaveExisteScreen extends StatelessWidget {
//   const ChaveExisteScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Minha Chave Flux')),
//       body: const Center(
//         child: Text(
//           'Sua chave Flux:\nxxxxxxxxxxxx',
//           style: TextStyle(fontSize: 24),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }