import 'package:etech_store_admin/main.dart';
import 'package:etech_store_admin/module/category/views/category_screen.dart';
import 'package:etech_store_admin/module/discount/views/discount_add_screen.dart';
import 'package:etech_store_admin/module/discount/views/discount_screen.dart';
import 'package:etech_store_admin/module/homepage/views/homepage.dart';
import 'package:etech_store_admin/module/oerder/view/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/preview/views/preview_screen.dart';
import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/view/product_add_screen.dart';
import 'package:etech_store_admin/module/product/view/product_management_screen.dart';
import 'package:etech_store_admin/module/profile/view/add_user_screen.dart';
import 'package:etech_store_admin/module/profile/view/profile_manage_desktop_screen.dart';
import 'package:etech_store_admin/module/report/views/report_screen.dart';
import 'package:etech_store_admin/module/wishlist/views/wishlist_screen.dart';
import 'package:etech_store_admin/services/auth_services.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenDesktop extends StatefulWidget {
  HomeScreenDesktop({super.key,required this.selectedIndex});
  int selectedIndex = 0;
  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop> {
  

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ProfileManageDesktopScreen(),
    const OrderManageDesktopScreen(),
    const CategoryScreen(),
    const PreviewScreen(),
    const WishListScreen(),
    const ReportScreen(),
    const AddUserScreen(),
    ProductManageDesktopScreen(),
    AddProductScreen(),
    const DisCountScreen(),
    AddDiscountScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  ProductController controller = Get.put(ProductController());
  ProductSampleController controllerSanple = Get.put(ProductSampleController());
  AuthServices auth = Get.put(AuthServices());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            color: Color.fromARGB(255, 29, 46, 79),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 46, 79),
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
                    _onItemTapped(0);
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Người Dùng', style: TextStyle(color: Colors.white)),
                  children: [
                    ListTile(
                      title: const Text('Quản Lý Người Dùng', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(1);
                      },
                    ),
                    ListTile(
                      title: const Text('Thêm Người Dùng Mới', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(7);
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
                        _onItemTapped(8);
                      },
                    ),
                    ListTile(
                      title: const Text('Thêm Sản Phẩm', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(9);
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
                        _onItemTapped(10);
                      },
                    ),
                    ListTile(
                      title: const Text('Thêm Khuyến Mãi', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _onItemTapped(11);
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
                        _onItemTapped(2);
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
                    _onItemTapped(3);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  title: const Text('Đánh giá sản phẩm', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(4);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  title: const Text('Sản phẩm yêu thích', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(5);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                  title: const Text('Báo cáo & Thống kê', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _onItemTapped(6);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                  child: ListTile(
                    leading: const Icon(Icons.login_sharp, color: Colors.white),
                    title: const Text('Đăng Xuất', style: TextStyle(color: Colors.redAccent)),
                    onTap: () {
                      auth.signOut();
                    },
                  ),
                ),
                // Add more list tiles here for other menu items
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: _widgetOptions.elementAt(widget.selectedIndex),
          ),
        ],
      ),
    );
  }
}
