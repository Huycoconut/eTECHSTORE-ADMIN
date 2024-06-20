import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_services.dart';
import '../../../utlis/constants/image_key.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    AuthServices auth = Get.put(AuthServices());
    final media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Header of the Drawer
                Material(
                  child: InkWell(
                    onTap: () {
                      /// Close Navigation drawer before
                      Navigator.pop(context);
                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Image.asset(
                            ImageKey.logoEtechStore,
                            width: 70,
                            height: 60,
                          ),
                          const Text("e T E C H S T O R E", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Header Menu items
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home_outlined),
                      title: Text('Home'),
                      onTap: () {
                        /// Close Navigation drawer before
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Người Dùng'),
                      onTap: () {
                        /// Close Navigation drawer before
                        Navigator.pop(context);
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen()),);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.ac_unit_sharp),
                      title: Text('Sản Phâm'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.sticky_note_2_rounded),
                      title: Text('Mã Giảm Giá'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.local_shipping),
                      title: Text('Đơn Hàng'),
                      onTap: () {},
                    ),
                    const Divider(
                      color: Colors.black45,
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Đăng Xuất'),
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
