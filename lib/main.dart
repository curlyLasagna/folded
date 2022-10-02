import 'package:flutter/material.dart';
import 'package:folded/app_colors.dart';
import 'tshirt.dart';
import 'app_colors.dart';

void main() => runApp(const MaterialApp(home: FirstRoute()));
class AppThemeDataFactory {
  static ThemeData prepareThemeData() => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        accentColor: AppColors.textPrimary,
        backgroundColor: AppColors.background,
      );

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
