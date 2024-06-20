import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileManageDesktopScreen extends StatefulWidget {
  const ProfileManageDesktopScreen({super.key});

  @override
  State<ProfileManageDesktopScreen> createState() => _ProfileManageDesktopScreenState();
}

class _ProfileManageDesktopScreenState extends State<ProfileManageDesktopScreen> {
  Stream<List<ProfileModel>> getUsers() {
    return FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ProfileModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateUserStatus(String uid, bool status) async {
    await FirebaseFirestore.instance.collection('Users').doc(uid).update({'TrangThai': status ? 1 : 0});
  }

  Future<void> deleteUser(String uid) async {
    TLoaders.successDialogError(
        message: '* Dữ liệu không thể khôi phục',
        title: 'Bạn có chắc chăn muốn xóa?',
        context: context,
        accept: () => FirebaseFirestore.instance.collection('Users').doc(uid).delete(),
        closeDialog: () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Người Dùng'),
        backgroundColor: Colors.red,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Add your onPressed code here!
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm Người Dùng Mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<ProfileModel>>(
                stream: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có dữ liệu'));
                  } else {
                    List<ProfileModel> users = snapshot.data!;
                    return SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: MediaQuery.of(context).size.width / 200,
                          dividerThickness: 0,
                          dataRowColor: MaterialStateProperty.all(Colors.transparent),
                          columns: const [
                            DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Tên Người Dùng', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Số Điện Thoại', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Địa Chỉ', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Khóa', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: List<DataRow>.generate(
                            growable: true,
                            users.length,
                            (index) => DataRow(
                              color: MaterialStateColor.resolveWith((states) => index.isEven ? Colors.white : TColros.grey_wheat),
                              cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(users[index].HoTen)),
                                DataCell(Text(users[index].Email)),
                                DataCell(Text(users[index].SoDienThoai.toString())),
                                DataCell(Text(users[index].DiaChi)),
                                DataCell(UserSwitch(uid: users[index].uid, status: users[index].TrangThai == 1)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          // Add your onPressed code here!
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          deleteUser(users[index].uid);
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
                    );
                  }
                },
              ),
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
