import 'package:flutter/material.dart';
import 'package:folded/app_colors.dart';
import 'tshirt.dart';
import 'app_colors.dart';

void main() => runApp(const MaterialApp(home: FirstRoute()));

class AppThemeDataFactory {
  static ThemeData prepareThemeData() => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xC3CCE1),
        backgroundColor: const Color(0xD4CAC6),
      );
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff085F63),
      appBar: AppBar(
        title: const Text('Folded'),
        backgroundColor: const Color(0xffC3CCE1),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: const Color(0xffC3CCE1)),
          child: const Text('👕 T-shirt'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TShirtPage()),
            );
          },
        ),
      ),
    );
  }
}
