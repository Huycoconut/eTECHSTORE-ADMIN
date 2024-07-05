import 'package:etech_store_admin/module/profile/view/desktop/add_user_screen.dart';
import 'package:etech_store_admin/module/oerder_manage/view/order_manage_screen.dart';
import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/view/product_management_screen.dart';
import 'package:etech_store_admin/module/profile/view/profile_manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utlis/constants/image_key.dart';
import '../../../product/view/product_add_screen.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ProfileManageScreen(),
    AddProductScreen(),
    ProductManageDesktopScreen(),
    const OrderManageScreen(),
    const AddUserScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ProductController controller = Get.put(ProductController());
  ProductSampleController controllerSanple = Get.put(ProductSampleController());
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
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                  ),
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
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text('Trang Chủ', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle home tap
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Người Dùng', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Người Dùng', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(0);
                      },
                    ),
                    ListTile(
                      title: const Text('Thêm Người Dùng Mới', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(4);
                      },
                    ),
                    ListTile(
                      title: const Text('Quản Trị Viên', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Navigate to specific screen
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.card_giftcard_rounded, color: Colors.white),
                  title: const Text('Sản Phẩm', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Sản Phẩm', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(2);
                        controllerSanple.clearControllers();
                        controllerSanple.addAtribute.value = false;
                        controller.setDefault();
                      },
                    ),
                    ListTile(
                      title: const Text('Thêm Sản Phẩm Mới', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(1);
                        controller.setDefault();
                      },
                    ),
                    /*     ListTile(
                      title: const Text('Chi Tiết Sản Phẩm', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(5);
                      },
                    ), */
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.ac_unit_rounded, color: Colors.white),
                  title: const Text('Đơn Hàng', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Đơn Hàng', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(3);
                      },
                    ),
                    /*   ListTile(
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
                    ), */
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
