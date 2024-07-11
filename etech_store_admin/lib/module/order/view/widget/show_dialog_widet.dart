import 'package:etech_store_admin/module/order/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/order/model/detail_orders.dart';
import 'package:etech_store_admin/module/order/model/orders_model.dart';
import 'package:etech_store_admin/module/order/view/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/order/view/widget/dropDownButoon_change_widget.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowDiaLogOrderDetail {
  static Future<void> showOrderDetails(BuildContext context, OrdersModel orderdata, ProfileModel profile, final maDonHang) async {
    final OrderManageController controller = Get.put(OrderManageController());
    late int temp;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông Tin Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Divider(),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text("Họ Tên: ", style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text("Số Điện Thoại: ", style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text("Email: ", style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text("Địa Chỉ: ", style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text("Trạng thái đơn: ", style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text("Thời gian tạo: ", style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 7),
                              Text('Thay đổi trạng thái đơn hàng', style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.HoTen),
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
                                              : "Chờ xác nhận",
                                  style: TextStyle(
                                      color: orderdata.isBeingShipped == true
                                          ? Colors.red
                                          : orderdata.isShipped == true
                                              ? Colors.orange
                                              : orderdata.isCompleted == true
                                                  ? Colors.green
                                                  : Colors.blue)),
                              const SizedBox(height: 5),
                              Text(DateFormat('dd-MM-yyyy, hh:mm a').format(orderdata.ngayTaoDon.toDate())),
                              const SizedBox(height: 5),
                              orderdata.isBeingShipped == false
                                  ? DropDownButtonChangeWidget(maDonHang: maDonHang)
                                  : Container(
                                      alignment: Alignment.centerLeft,
                                      height: 23,
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration:
                                          BoxDecoration(color: const Color.fromARGB(255, 205, 204, 204), borderRadius: BorderRadius.circular(5)),
                                      child: const Text("Không thể thay đổi trạng thái đơn hàng", style: TextStyle(color: Colors.black)),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Thông tin sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const Divider(),
                    StreamBuilder<List<OrdersModel>>(
                        stream: controller.getOrder(),
                        builder: (context, snapshot) {
                          List<OrdersModel> donHangs = snapshot.data!;

                          List<OrdersModel> userOrders = donHangs.where((order) => order.maKhachHang == profile.uid).toList();
                          if (snapshot.hasError) {
                            return Center(child: Text('Lỗi: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('++++ Không có dữ liệu ${snapshot.data} + ${snapshot.data!.isEmpty}'));
                          } else {
                            List<OrdersModel> orders = snapshot.data!;

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
                                          return const Center(child: CircularProgressIndicator());
                                        } else {
                                          List<DetailOrders> ctDonHangs = snapshot.data!;
                                          List<DetailOrders> filteredCTDonHangs = ctDonHangs
                                              .where((ctDonHang) => userOrders.any((donHang) => donHang.id == ctDonHang.maDonHang))
                                              .toList();

                                          return FittedBox(
                                            fit: BoxFit.contain,
                                            child: DataTable(
                                              dataRowHeight: 70,
                                              columns: const [
                                                DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                                                DataColumn(label: Text('Tên sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                                                DataColumn(label: Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                                                DataColumn(label: Text('Giá gốc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                                                DataColumn(
                                                    label: Text('Giá khuyến mãi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                                                DataColumn(label: Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
                                              ],
                                              rows: List<DataRow>.generate(
                                                filteredCTDonHangs.length,
                                                (index) {
                                                  DetailOrders ctDonHang = filteredCTDonHangs[index];
                                                  ProductModel product = filterProduct.firstWhere((p) => p.id == ctDonHang.maMauSanPham['MaSanPham']);
                                                  OrdersModel order = fillterOrder.firstWhere((o) => o.id == ctDonHang.maDonHang);
                                                  orders.add(order);
                                                  int allPrice =
                                                      ((product.giaTien - (product.giaTien * product.KhuyenMai ~/ 100)) * ctDonHang.soLuong);
                                                  temp = allPrice;
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
                                                      DataCell(Text(priceFormat(product.giaTien), style: const TextStyle(fontSize: 25))),
                                                      DataCell(Text(priceFormat((ctDonHang.giaTien)), style: const TextStyle(fontSize: 25))),
                                                      DataCell(Text(priceFormat((ctDonHang.giaTien) * ctDonHang.soLuong),
                                                          style: const TextStyle(fontSize: 25))),
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
                    Text('Tổng thành tiền: ${priceFormat(orderdata.tongTien)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
