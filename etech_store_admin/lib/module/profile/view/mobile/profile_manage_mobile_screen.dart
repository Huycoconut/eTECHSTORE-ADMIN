import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utlis/helpers/popups/loader.dart';
import '../../model/profile_model.dart';

class ProfileManageMobileScreen extends StatelessWidget {
  const ProfileManageMobileScreen({super.key});

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
    await FirebaseFirestore.instance.collection('Users').doc(uid).delete().then((value) {
      TLoaders.successSnackBar(title: "Thông báo", message: "Xóa thành công");
    }).onError((error, stackTrace) {
      TLoaders.errorSnackBar(title: 'Thông báo', message: "Xóa thất bại");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Người Dùng'),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<ProfileModel>>(
                stream: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có dữ liệu'));
                  } else {
                    List<ProfileModel> users = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 200,
                        child: DataTable(
                          columnSpacing: MediaQuery.of(context).size.width / 200,
                          columns: [
                            DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                            DataColumn(label: Text('Tên Người Dùng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                            DataColumn(label: Text('Số Điện Thoại', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                            DataColumn(label: Text('Địa Chỉ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                            DataColumn(label: Text('Khóa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                            DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7))),
                          ],
                          rows: List<DataRow>.generate(
                            growable: true,
                            users.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Text((index + 1).toString(), style: TextStyle(fontSize: 8))),
                                DataCell(Text(users[index].HoTen, style: TextStyle(fontSize: 8))),
                                DataCell(Text(users[index].Email, style: TextStyle(fontSize: 8))),
                                DataCell(Text(users[index].SoDienThoai.toString(), style: TextStyle(fontSize: 8))),
                                DataCell(Text(users[index].DiaChi, style: TextStyle(fontSize: 8))),
                                DataCell(UserSwitch(uid: users[index].uid, status: users[index].TrangThai == 1)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue, size: 10),
                                        onPressed: () {
                                          // Add your onPressed code here!
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red, size: 10),
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

  UserSwitch({required this.uid, required this.status});

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
    return Transform.scale(
      scale: 0.3,
      child: CupertinoSwitch(
        value: _status!,
        onChanged: (bool value) {
          setState(() {
            _status = value;
          });
          updateUserStatus(widget.uid, value);
        },
      ),
    );
  }
}
