import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:drawer_flutter/env.dart';

class CarteiraScreen extends StatefulWidget {
  const CarteiraScreen({super.key});

  @override
  State<CarteiraScreen> createState() => _CarteiraScreenState();
}

class _CarteiraScreenState extends State<CarteiraScreen> {
  Future<double>? _saldoFuture;

  Future<double> _buscarSaldo() async {
    final prefs = await SharedPreferences.getInstance(); // import 'package:shared_preferences/shared_preferences.dart';
    final idUsuario = prefs.getInt('usuarioId');

    if (idUsuario == null) {
      throw Exception('ID do usuário não encontrado');
    }

    final response = await http.get(  // import 'package:http/http.dart' as http;
      Uri.parse('$baseUrl/banco-carteira/buscar-carteira?idUsuario=$idUsuario'), // $baseUrl -> import 'package:drawer_flutter/env.dart';
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body); // import 'dart:convert';
      final data = json['data'];
      final carteira = data[0];
      return carteira['saldo'];
    } else {
      throw Exception('Erro ao buscar saldo');
      // Center(child: Text('Usuario não possui carteira cadastrada'));
    }
  }

  @override
  void initState() {
    super.initState();
    _saldoFuture = _buscarSaldo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saldo/Carteira'),
      ),
      body: FutureBuilder<double>(
        future: _saldoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final saldo = snapshot.data!;
            final saldoFormatado = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(saldo); // import 'package:intl/intl.dart';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Seu saldo atual é:',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    saldoFormatado,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Saldo não encontrado'));
          }
        },
      ),
    );
  }
  
}


// class CarteiraScreen extends StatelessWidget{
//   const CarteiraScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saldo/Carteira'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Seu saldo atual é:',
//               style: TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'R\$ 1.000,00',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigator.pop(context);
//                 Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//               },
//               child: const Text('Voltar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }