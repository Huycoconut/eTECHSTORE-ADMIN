import 'package:etech_store_admin/module/profile/view/desktop/profile_manage_desktop_screen.dart';
import 'package:etech_store_admin/module/profile/view/mobile/profile_manage_mobile_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProfileManageScreen extends StatefulWidget {
  const ProfileManageScreen({super.key});

  @override
  State<ProfileManageScreen> createState() => _ProfileManageScreenState();
}

class _ProfileManageScreenState extends State<ProfileManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ScreenTypeLayout(
                mobile: const ProfileManageMobileScreen(),
                desktop: const ProfileManageDesktopScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
