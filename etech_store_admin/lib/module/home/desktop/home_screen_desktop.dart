import 'package:etech_store_admin/module/oerder_manage/view/order_manage_screen.dart';
import 'package:etech_store_admin/module/profile/view/profile_manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utlis/constants/image_key.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProfileManageScreen(),
    OrderManageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            color: Colors.blueGrey[900],
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Image.asset(
                        ImageKey.logoEtechStore,
                        width: 90,
                        height: 90,
                      ),
                      const Text("e T E C H S T O R E", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Trang Chủ', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle home tap
                  },
                ),
                ExpansionTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text('Người Dùng', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: Text('Quản Lý Người Dùng', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(0);
                      },
                    ),
                    ListTile(
                      title: Text('Thêm Người Dùng Mới', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Get.toNamed('/SignIn');
                      },
                    ),
                    ListTile(
                      title: Text('Quản Trị Viên', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Navigate to specific screen
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.ac_unit_rounded, color: Colors.white),
                  title: Text('Đơn Hàng', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: Text('Quản Lý Đơn Hàng', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(1);
                      },
                    ),
                    ListTile(
                      title: Text('Thêm Người Dùng Mới', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Get.toNamed('/SignIn');
                      },
                    ),
                    ListTile(
                      title: Text('Quản Trị Viên', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Navigate to specific screen
                      },
                    ),
                  ],
                ),
                // Add more list tiles here for other menu items
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
