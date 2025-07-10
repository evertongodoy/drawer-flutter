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