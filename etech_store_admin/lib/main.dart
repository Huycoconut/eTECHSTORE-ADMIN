import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etech_store_admin/module/auth/views/home_sign_in.dart';
import 'package:etech_store_admin/module/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBsPYtDU2poc8ueawn0lyV725C_ZeeCFas",
      appId: "1:1032898699752:web:19e46fb35a76c22081045d",
      messagingSenderId: "1032898699752",
      projectId: "etechstore-abe5c",
    ),
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
      builder: (light, dark) {
        User? user = FirebaseAuth.instance.currentUser;
        return GetMaterialApp(
          theme: light,
          darkTheme: dark,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const AuthWrapper()),
          ],
        );
      }));
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return const Home();
        } else {
          return const HomeSignIn();
        }
      },
    );
  }
}
