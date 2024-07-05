import 'package:etech_store_admin/module/oerder_manage/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/oerder_manage/model/detail_orders.dart';
import 'package:etech_store_admin/module/oerder_manage/model/orders_model.dart';
import 'package:etech_store_admin/module/oerder_manage/view/desktop/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
 import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowDetailOrderMobile {
  static Future<void> showOrderDetails(BuildContext context, OrdersModel orderdata, ProfileModel profile, final maDonHang) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final OrderManageController controller = Get.put(OrderManageController());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Chi tiết đơn hàng'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông Tin Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Divider(),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text("Họ Tên: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("Số Điện Thoại: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("Địa Chỉ: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("Trạng thái đơn: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("Thời gian tạo: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile.HoTen, style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 5),
                            Text('0${profile.SoDienThoai}'),
                            const SizedBox(height: 5),
                            Text(profile.Email),
                            const SizedBox(height: 5),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.31,
                                child: Text(profile.DiaChi, overflow: TextOverflow.ellipsis, maxLines: 2, softWrap: true)),
                            const SizedBox(height: 5),
                            Text(
                                orderdata.isBeingShipped == true
                                    ? "Đã Hủy"
                                    : orderdata.isShipped == true
                                        ? "Đang vận chuyển"
                                        : orderdata.isCompleted == true
                                            ? "Hoàn thành"
                                            : orderdata.isCancelled == true
                                                ? "Trả hàng"
                                                : orderdata.isPaid == true
                                                    ? "Chờ xác nhận"
                                                    : "",
                                style: TextStyle(
                                    color: orderdata.isBeingShipped == true
                                        ? Colors.red
                                        : orderdata.isShipped == true
                                            ? Colors.orange
                                            : orderdata.isCompleted == true
                                                ? Colors.green
                                                : orderdata.isCancelled == true
                                                    ? Colors.purple
                                                    : orderdata.isPaid == true
                                                        ? Colors.blue
                                                        : Colors.black)),
                            const SizedBox(height: 5),
                            Text(DateFormat('dd-MM-yyyy, hh:mm a').format(orderdata.ngayTaoDon.toDate())),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Thay đổi trạng thái đơn hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  FutureBuilder(
                    future: controller.fetchOrder(maDonHang),
                    builder: (context, snapshot) {
                      return Obx(() {
                        return DropdownButton<String>(
                          value: controller.getSelectedStatus(),
                          items: const [
                            DropdownMenuItem(value: 'Paid', child: Text('Chờ xác nhận')),
                            DropdownMenuItem(value: 'Being Shipped', child: Text('Đã hủy')),
                            DropdownMenuItem(value: 'Shipped', child: Text('Đang vận chuyển')),
                            DropdownMenuItem(value: 'Completed', child: Text('Thành công')),
                            DropdownMenuItem(value: 'Cancelled', child: Text('Trả hàng')),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.updateOrder(maDonHang, newValue);
                            }
                          },
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Thông tin sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  StreamBuilder<List<OrdersModel>>(
                      stream: controller.getOrder(),
                      builder: (context, snapshot) {
                        List<OrdersModel> donHangs = snapshot.data!;
                        List<OrdersModel> fillterOrder = donHangs.toList();

                        List<OrdersModel> userOrders = donHangs.where((order) => order.maKhachHang == profile.uid).toList();
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Không có dữ liệu'));
                        } else {
                          List<OrdersModel> orders = snapshot.data!;
                          List<OrdersModel> order = [];

                          return StreamBuilder<List<ProductModel>>(
                            stream: controller.getProduct(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                List<ProductModel> sanPham = snapshot.data!;

                                List<ProductModel> filterProduct = sanPham.toList();
                                List<OrdersModel> fillterOrder = donHangs.toList();
                                return StreamBuilder<List<DetailOrders>>(
                                    stream: controller.getCTDonHangs(maDonHang),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        print("không có dữ liệu!");
                                        return const Center(child: CircularProgressIndicator());
                                      } else {
                                        List<DetailOrders> ctDonHangs = snapshot.data!;
                                        List<DetailOrders> filteredCTDonHangs =
                                            ctDonHangs.where((ctDonHang) => userOrders.any((donHang) => donHang.id == ctDonHang.maDonHang)).toList();

                                        return FittedBox(
                                          fit: BoxFit.contain,
                                          child: DataTable(
                                            dataRowHeight: 70,
                                            columns: const [
                                              DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                              DataColumn(label: Text('Tên sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                              DataColumn(label: Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                              DataColumn(label: Text('Giá khuyến mãi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                              DataColumn(label: Text('Giá gốc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                              DataColumn(label: Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                            ],
                                            rows: List<DataRow>.generate(
                                              filteredCTDonHangs.length,
                                              (index) {
                                                DetailOrders ctDonHang = filteredCTDonHangs[index];
                                                ProductModel product = filterProduct.firstWhere((p) => p.id == ctDonHang.maMauSanPham['MaSanPham']);
                                                OrdersModel order = fillterOrder.firstWhere((o) => o.id == ctDonHang.maDonHang);
                                                orders.add(order);
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text((index + 1).toString(), style: const TextStyle(fontSize: 25))),
                                                    DataCell(SizedBox(
                                                        width: MediaQuery.of(context).size.width / 4.2,
                                                        child: Text(product.ten.toString(),
                                                            style: const TextStyle(fontSize: 25),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            softWrap: true))),
                                                    DataCell(Text(ctDonHang.soLuong.toString(), style: const TextStyle(fontSize: 25))),
                                                    DataCell(Text(priceFormat((product.giaTien - product.giaTien * product.KhuyenMai ~/ 100)),
                                                        style: const TextStyle(fontSize: 25))),
                                                    DataCell(Text(priceFormat(product.giaTien), style: const TextStyle(fontSize: 25))),
                                                    DataCell(Text(priceFormat(order.tongTien), style: const TextStyle(fontSize: 25))),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    });
                              }
                            },
                          );
                        }
                      }),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text('Tổng thành tiền: ${priceFormat(orderdata.tongTien)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hủy đơn hàng"),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Chuyển cho đơn vị vận chuyển"),
            ),
          ],
        );
      },
    );
  }
}
