import 'package:drawer_flutter/models/extrato.dart';
import 'package:flutter/material.dart';
import 'package:drawer_flutter/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class ExtratoScreen extends StatefulWidget {
  const ExtratoScreen({super.key});

  @override
  State<ExtratoScreen> createState() => _ExtratoScreenState();
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  List<Extrato> _extratos = [];
  bool _carregando = true;
  String? _erro;
  int? _idConta;

  @override
  void initState() {
    super.initState();
    _carregarExtratos();
  }

  Future<void> _carregarExtratos() async {
    try {
      final prefs = await SharedPreferences.getInstance(); // import 'package:shared_preferences/shared_preferences.dart';
      final idUsuario = prefs.getInt('usuarioId');
      final idConta = prefs.getInt('contaId');

      if(idConta == 0){
        setState(() {
          _erro = 'Usuario não possui conta cadastrada';
          _carregando = false;
        });
        return;
      }
      if (idUsuario == null || idConta == null) {
        setState(() {
          _erro = 'ID do usuário ou conta não encontrado';
          _carregando = false;
        });
        return;
      }

      _idConta = idConta;

      final url = Uri.parse('$baseUrl/banco-extrato/listar-extratos/extrato?idUsuario=$idUsuario'); // import 'package:drawer_flutter/env.dart';
      final response = await http.get(url); // import 'package:http/http.dart' as http;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body); // import 'dart:convert';
        final List<dynamic> data = json['data'];
        // final extratos = data.map((e) => Extrato.fromJson(e)).toList();
        final extratos = data.map((e) => Extrato.fromJson(e)).toList()
        ..sort((a, b) => b.id.compareTo(a.id)); // ordenação decrescente por ID, .. é o operador cascade do Dart , operador permite encadear múltiplas operações no mesmo objeto, sem precisar repetir o nome dele.

        setState(() {
          _extratos = extratos;
          _carregando = false;
        });
      } else {
        setState(() {
          _erro = 'Erro: ${response.statusCode}';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro na requisição: $e';
        _carregando = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extrato')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(child: Text(_erro!))
              : ListView.builder(
                  itemCount: _extratos.length,
                  itemBuilder: (context, index) {
                    final extrato = _extratos[index];
                    final isSaida = extrato.idContaOrigem == _idConta;
                    final icon = isSaida ? Icons.money_off : Icons.attach_money;
                    final cor = isSaida ? Colors.red : Colors.green;

                    return ListTile(
                      leading: Icon(icon, color: cor),
                      title: Text(
                        'Valor: R\$ ${extrato.valor.toStringAsFixed(2)}',
                        style: TextStyle(color: cor),
                      ),
                      subtitle: Text(
                        'Data: ${DateFormat('dd/MM/yyyy').format(extrato.dataLancamento)}', // DATEFORMAT import 'package:intl/intl.dart';
                        style: const TextStyle(fontSize: 14),
                      ),
                      // subtitle: Text(
                      //   'Data: ${extrato.dataLancamento}',
                      //   style: const TextStyle(fontSize: 14),
                      // ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            // isSaida ? 'Para: Conta ${extrato.idContaDestino}' : 'De: Conta ${extrato.idContaOrigem}',
                            isSaida ? 'Para: ${extrato.pessoaDestino}' : 'De: ${extrato.pessoaOrigem}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

/*
class ExtratoScreen extends StatelessWidget {
  const ExtratoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(16.0),
              child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.attach_money, size: 35),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'R\$ 1.000,00',
                              style: TextStyle(fontSize: 24),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Text(
                              '10/07/2025',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )                        
                      ],
                    ),
                    // Icon(Icons.remove_circle_outline, size: 50),
                  ],
                ),
                Divider(
                  color: Color.fromARGB(255, 0, 0, 0),
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.money_off, size: 35),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'R\$ 1.000,00',
                              style: TextStyle(fontSize: 24),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Text(
                              '09/07/2025',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                    // Icon(Icons.remove_circle_outline, size: 50),
                  ],
                ),
              ],
            )
            ),
          ],
          // children: [
          //   const Text(
          //     'Extrato',
          //     style: TextStyle(fontSize: 24),
          //   ),
          //   ElevatedButton(
          //     onPressed: () {
          //       // Navigator.pop(context);
          //       Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          //     },
          //     child: const Text('Voltar'),
          //   ),
          // ],
        ),
      ),
    );
  }
}
*/