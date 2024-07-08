import 'package:etech_store_admin/module/oerder_manage/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/oerder_manage/model/orders_model.dart';
import 'package:etech_store_admin/module/oerder_manage/view/desktop/widget/show_dialog_widet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../profile/model/profile_model.dart';

class OrderManageMobileScreen extends StatelessWidget {
  const OrderManageMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    OrderManageController controller = Get.put(OrderManageController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Đơn Hàng'),
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Text(
              "Tìm Kiếm Đơn Hàng",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(5), // Added this
                      labelText: 'Tìm kiếm Mã Đơn Hàng',
                      labelStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(5), // Added this
                      labelText: 'Tìm kiếm Người Đặt',
                      labelStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(5), // Added this
                      labelText: 'Tìm kiếm Trạng Thái',
                      labelStyle: TextStyle(fontSize: 10),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Quản Lý Đơn Hàng",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<OrdersModel>>(
                stream: controller.getOrder(),
                builder: (context, orderSnapshot) {
                  if (orderSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (orderSnapshot.hasError) {
                    return Center(child: Text('Lỗi: ${orderSnapshot.error}'));
                  } else if (!orderSnapshot.hasData || orderSnapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có dữ liệu'));
                  } else {
                    List<OrdersModel> orders = orderSnapshot.data!;
                    return StreamBuilder<List<ProfileModel>>(
                      stream: controller.fetchProfilesStream(),
                      builder: (context, profileSnapshot) {
                        if (profileSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (profileSnapshot.hasError) {
                          return Center(child: Text('Lỗi: ${profileSnapshot.error}'));
                        } else if (!profileSnapshot.hasData || profileSnapshot.data!.isEmpty) {
                          return const Center(child: Text('Không có dữ liệu người dùng'));
                        } else {
                          List<ProfileModel> profiles = profileSnapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  child: DataTable(
                                    columnSpacing: MediaQuery.of(context).size.width / 32,
                                    columns: const [
                                      DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8))),
                                      DataColumn(label: Text('Mã Đơn Hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8))),
                                      DataColumn(label: Text('Tên Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8))),
                                      DataColumn(label: Text('Ngày Đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8))),
                                      DataColumn(label: Text('Trạng Thái', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8))),
                                      DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8))),
                                    ],
                                    rows: List<DataRow>.generate(
                                      orders.length,
                                      (index) {
                                        final order = orders[index];
                                        final profile = profiles.firstWhere((profile) => profile.uid == order.maKhachHang,
                                            orElse: () => ProfileModel(
                                                DiaChi: "",
                                                Email: "",
                                                HinhDaiDien: "",
                                                HoTen: "",
                                                Password: "",
                                                Quyen: true,
                                                SoDienThoai: 1234567,
                                                TrangThai: 1,
                                                uid: ""));
                                        return DataRow(
                                          cells: [
                                            DataCell(Text((index + 1).toString(), style: const TextStyle(fontSize: 10))),
                                            DataCell(Text(order.id, style: const TextStyle(fontSize: 10))),
                                            DataCell(Text(profile.HoTen ?? 'Không có tên', style: const TextStyle(fontSize: 10))),
                                            DataCell(Text(DateFormat('dd-MM-yyyy, hh:mm a').format(order.ngayTaoDon.toDate()),
                                                style: const TextStyle(fontSize: 10))),
                                            DataCell(Text(
                                              order.isBeingShipped == true
                                                  ? "Đã Hủy"
                                                  : order.isShipped == true
                                                      ? "Đang vận chuyển"
                                                      : order.isCompleted == true
                                                          ? "Thành công"
                                                          : order.isPaid == true
                                                              ? "Đang chuẩn bị"
                                                              : "",
                                              style: TextStyle(
                                                  color: order.isBeingShipped == true
                                                      ? Colors.red
                                                      : order.isShipped == true
                                                          ? Colors.orange
                                                          : order.isCompleted == true
                                                              ? Colors.green
                                                              : order.isPaid == true
                                                                  ? Colors.blue
                                                                  : Colors.black,
                                                  fontSize: 10),
                                            )),
                                            DataCell(ElevatedButton(
                                              onPressed: () {
                                                //  Get.dialog();
                                                ShowDiaLogOrderDetail.showOrderDetails(context, order, profile, order.id);
                                              },
                                              child: const Text("Chi tiết", style: TextStyle(fontSize: 10)),
                                            )),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
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

String priceFormat(int price) {
  final priceOutput = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return priceOutput.format(price);
}
