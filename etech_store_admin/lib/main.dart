import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:etech_store_admin/module/auth/views/home_sign_in.dart';
import 'package:etech_store_admin/module/home/view/home_screen_desktop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();

  };
await dotenv.load(fileName: "assets/noti.env");
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBsPYtDU2poc8ueawn0lyV725C_ZeeCFas",
        authDomain: "etechstore-abe5c.firebaseapp.com",
        databaseURL: "https://etechstore-abe5c-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "etechstore-abe5c",
        storageBucket: "etechstore-abe5c.appspot.com",
        messagingSenderId: "1032898699752",
        appId: "1:1032898699752:web:19e46fb35a76c22081045d"),
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
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
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
          return HomeScreenDesktop(
            selectedIndex: 0,
          );
        } else {
          return const HomeSignIn();
        }
      },
    );
  }
}
