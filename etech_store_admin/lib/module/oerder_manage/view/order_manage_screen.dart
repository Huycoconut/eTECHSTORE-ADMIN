import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop/order_manage_screen_desktop.dart';
import 'mobile/order_manage_screen_mobile.dart';

class OrderManageScreen extends StatelessWidget {
  const OrderManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ScreenTypeLayout(
                mobile: OrderManageMobileScreen(),
                desktop: OrderManageDesktopScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
