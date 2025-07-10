import 'package:flutter/material.dart';


class ChaveTransferencia extends StatelessWidget {
  const ChaveTransferencia({super.key});

  @override
  Widget build(BuildContext context) {
    // create a scaffold of screen that will be used
    // to keep a key like a PIX to do transfers
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Chave de Transferência'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insira sua chave PIX para transferência:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Chave PIX',
                hintText: 'Digite sua chave PIX',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for transfer confirmation
              },
              child: const Text('Confirmar Transferência'),
            ),
          ],
        ),
      ),
    );
  }
}