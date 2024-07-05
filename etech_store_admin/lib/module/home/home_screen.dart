import 'package:etech_store_admin/module/home/view/desktop/home_screen_desktop.dart';
import 'package:etech_store_admin/module/home/view/mobile/home_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeSignInState();
}

class _HomeSignInState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ScreenTypeLayout(
                mobile: const HomeScreenMobile(),
                desktop: const HomeScreenDesktop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
