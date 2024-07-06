import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/product/view/widget/pagination_product_widget.dart';
import 'package:etech_store_admin/module/profile/controller/profile_controller.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:etech_store_admin/module/profile/view/widget/show_edit_profile_user.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileManageDesktopScreen extends StatelessWidget {
  const ProfileManageDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản Lý Người Dùng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: TColros.purple_line,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Xin Chào, Admin', style: TextStyle(color: Colors.white)),
                Icon(Icons.account_circle, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        //  width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            const Text(
              "Tìm Kiếm Người Dùng",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm Kiếm Tên Người Dùng',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchName.value = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm Kiếm E-mail',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchEmail.value = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm Kiếm Số Điện Thoại',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchPhone.value = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              flex: 15,
              child: StreamBuilder<List<ProfileModel>>(
                  stream: controller.getUsers(),
                  builder: (context, snapshot) {
                    return Obx(() {
                      List<ProfileModel> filteredUsers = controller.allUsers.where((user) {
                        bool matchesName = user.HoTen.toLowerCase().contains(controller.searchName.value.toLowerCase());
                        bool matchesEmail = user.Email.toLowerCase().contains(controller.searchEmail.value.toLowerCase());
                        bool matchesPhone = user.SoDienThoai.toString().contains(controller.searchPhone.value);

                        return matchesName && matchesEmail && matchesPhone;
                      }).toList();

                      if (controller.searchName.value.isEmpty && controller.searchEmail.value.isEmpty && controller.searchPhone.value.isEmpty) {
                        filteredUsers = controller.allUsers;
                      }

                      // Phân trang danh sách người dùng
                      int startIndex = (controller.currentPage.value - 1) * controller.itemsPerPage.value;
                      int endIndex = startIndex + controller.itemsPerPage.value;
                      List<ProfileModel> paginatedUsers = filteredUsers.sublist(startIndex, endIndex.clamp(0, filteredUsers.length));

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                dataRowMaxHeight: 70,
                                columns:   [
                                  DataColumn(label: Container(width: 30,child: Text('STT', style: TextStyle(fontWeight: FontWeight.bold)))),
                                  DataColumn(label: Text('Tên Người Dùng', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('E-mail', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Container(width: 100,child: Text('Số Điện Thoại', style: TextStyle(fontWeight: FontWeight.bold )))),
                                  DataColumn(label: Text('Địa Chỉ', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Khóa', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: List<DataRow>.generate(
                                  paginatedUsers.length,
                                  (index) => DataRow(
                                    color: MaterialStateColor.resolveWith((states) => index.isEven ? Colors.white : Colors.grey[200]!),
                                    cells: [
                                      DataCell(Container(width: 30,child: Text((index + 1).toString()))),
                                      DataCell(Container(width: 150,child: Text(paginatedUsers[index].HoTen))),
                                      DataCell(Container(width: 150,child: Text(paginatedUsers[index].Email))),
                                      DataCell(Container(width: 110,child: Text("0${paginatedUsers[index].SoDienThoai.toString()}"))),
                                      DataCell(Container(width: 300,child: Text(paginatedUsers[index].DiaChi))),
                                      DataCell(UserSwitch(uid: paginatedUsers[index].uid, status: paginatedUsers[index].TrangThai == 1)),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: Colors.blue),
                                              onPressed: () {
                                                ShowEditUser.showEditUser(context, paginatedUsers[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                TLoaders.showConfirmPopup(
                                                    title: "Cảnh báo",
                                                    description: "Xác nhận xóa không thể khôi phục!",
                                                    onDismissed: () => Container(),
                                                    conFirm: () =>
                                                        FirebaseFirestore.instance.collection('Users').doc(paginatedUsers[index].uid).delete());
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Pagination(
                              currentPage: controller.currentPage.value,
                              itemsPerPage: controller.itemsPerPage.value,
                              totalItems: filteredUsers.length,
                              onPageChanged: (page) => controller.updatePage(page),
                            ),
                          ],
                        ),
                      );
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSwitch extends StatefulWidget {
  final String uid;
  final bool status;

  const UserSwitch({super.key, required this.uid, required this.status});

  @override
  _UserSwitchState createState() => _UserSwitchState();
}

class _UserSwitchState extends State<UserSwitch> {
  bool? _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  void updateUserStatus(String uid, bool status) {
    FirebaseFirestore.instance.collection('Users').doc(uid).update({'TrangThai': status ? 1 : 0});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _status!,
      onChanged: (bool value) {
        setState(() {
          _status = value;
        });
        updateUserStatus(widget.uid, value);
      },
    );
  }
}
