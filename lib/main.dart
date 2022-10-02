import 'package:flutter/material.dart';
import 'tshirt.dart';

void main() => runApp(const MaterialApp(home: FirstRoute()));

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folded'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('T-shirt'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TShirt()),
            );
          },
        ),
      ),
    );
  }
}
