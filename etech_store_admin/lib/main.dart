import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etech_store_admin/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AdaptiveTheme(
    light: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
    ),
    dark: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue,
    ),
    initial: savedThemeMode ?? AdaptiveThemeMode.light,
    builder: (light, dark) => GetMaterialApp(
      theme: light,
      darkTheme: dark,
      home: const HomeSreen(),
    ),
  ));
}

class HomeSreen extends StatelessWidget {
  const HomeSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
