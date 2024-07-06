import 'package:etech_store_admin/main.dart';
import 'package:etech_store_admin/module/category/views/category_screen.dart';
import 'package:etech_store_admin/module/discount/views/discount_screen.dart';
import 'package:etech_store_admin/module/oerder_manage/view/order_manage_screen.dart';
import 'package:etech_store_admin/module/preview/views/preview_screen.dart';
import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/view/product_add_screen.dart';
import 'package:etech_store_admin/module/product/view/product_management_screen.dart';
import 'package:etech_store_admin/module/profile/view/desktop/add_user_screen.dart';
import 'package:etech_store_admin/module/profile/view/profile_manage_screen.dart';
import 'package:etech_store_admin/module/report/views/report_screen.dart';
import 'package:etech_store_admin/module/wishlist/views/wishlist_screen.dart';
import 'package:etech_store_admin/services/auth_services.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ProfileManageScreen(),
    const OrderManageScreen(),
    const CategoryScreen(),
    const PreviewScreen(),
    const WishListScreen(),
    const ReportScreen(),
    const AddUserScreen(),
    ProductManageDesktopScreen(),
    AddProductScreen(),
    const DisCountScreen()
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
                        _onItemTapped(6);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.card_travel, color: Colors.white),
                  title: const Text('Sản Phẩm', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Sản Phẩm', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(7);
                      },
                    ),
                    ListTile(
                      title: const Text('Thêm Sản Phẩm', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(8);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.money_outlined, color: Colors.white),
                  title: const Text('Khuyến Mãi', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Khuyến Mãi', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(9);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.local_shipping_outlined, color: Colors.white),
                  title: const Text('Đơn Hàng', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Đơn Hàng', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(1);
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(
                    Icons.category,
                    color: Colors.white,
                  ),
                  title: const Text('Danh mục sản phẩm', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(2);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  title: const Text('Đánh giá sản phẩm', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(3);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  title: const Text('Sản phẩm yêu thích', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(4);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                  title: const Text('Báo cáo & Thống kê', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(5);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                  child: ListTile(
                    leading: const Icon(Icons.login_sharp, color: Colors.white),
                    title: const Text('Đăng Xuất', style: TextStyle(color: Colors.redAccent)),
                    onTap: () {
                      AuthServices.instance.auth.signOut().then((value) {
                        return const AuthWrapper();
                      });
                    },
                  ),
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
