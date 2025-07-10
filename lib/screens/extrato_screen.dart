import 'package:flutter/material.dart';

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
                    Icon(Icons.add_circle_outline, size: 35),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'R\$ 1.000,00',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text('Entrada'),
                      ],
                    ),
                    // Icon(Icons.remove_circle_outline, size: 50),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.remove_circle_outline, size: 35),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'R\$ 1.000,00',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text('Saída'),
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