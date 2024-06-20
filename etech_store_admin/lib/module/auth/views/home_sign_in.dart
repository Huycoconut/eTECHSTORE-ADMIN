import 'package:etech_store_admin/module/auth/views/desktop/sign_in_desktop.dart';
import 'package:etech_store_admin/module/auth/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeSignIn extends StatefulWidget {
  const HomeSignIn({super.key});

  @override
  State<HomeSignIn> createState() => _HomeSignInState();
}

class _HomeSignInState extends State<HomeSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ScreenTypeLayout(
                mobile: const SignInScreenMobile(),
                desktop: const SignInScreenDestop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
