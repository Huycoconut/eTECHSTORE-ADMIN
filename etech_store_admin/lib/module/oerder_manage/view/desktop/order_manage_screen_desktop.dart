import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/oerder_manage/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/oerder_manage/model/orders_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../product/model/product_model.dart';
import '../../../profile/model/profile_model.dart';
import '../../model/detail_orders.dart';

class OrderManageDesktopScreen extends StatelessWidget {
  const OrderManageDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<List<OrdersModel>> getOrder() {
      return FirebaseFirestore.instance
          .collection('DonHang')
          .orderBy('NgayTaoDon', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => OrdersModel.fromFirestore(doc)).toList());
    }

    Stream<List<ProfileModel>> fetchProfilesStream() {
      return FirebaseFirestore.instance
          .collection('Users')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => ProfileModel.fromMap(doc.data(), doc.id)).toList());
    }

    var products = <String, ProductModel>{};
    var ordersItem = <String, OrdersModel>{};
    Stream<List<DetailOrders>> getCTDonHangs(String maDonHang) {
      return FirebaseFirestore.instance
          .collection('CTDonHang')
          .where('MaDonHang', isEqualTo: maDonHang)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => DetailOrders.fromJson(doc.data())).toList());
    }

    Stream<List<ProductModel>> getProduct() {
      return FirebaseFirestore.instance
          .collection('SanPham')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList());
    }

    Future<void> showOrderDetails(BuildContext context, OrdersModel orderdata, ProfileModel profile, final maDonHang) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final OrderManageController controller = Get.put(OrderManageController());
      late int temp;
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
                              const SizedBox(height: 5),
                              FutureBuilder(
                                future: controller.fetchOrder(maDonHang),
                                builder: (context, snapshot) {
                                  return Obx(() {
                                    return Container(
                                      height: 23,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                      child: DropdownButton<String>(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 25,
                                        underline: const SizedBox(),
                                        value: controller.getSelectedStatus(),
                                        items: const [
                                          DropdownMenuItem(value: 'Paid', child: Text('Chờ xác nhận', style: TextStyle(fontSize: 14))),
                                          DropdownMenuItem(value: 'Being Shipped', child: Text('Đã hủy', style: TextStyle(fontSize: 14))),
                                          DropdownMenuItem(value: 'Shipped', child: Text('Đang vận chuyển', style: TextStyle(fontSize: 14))),
                                          DropdownMenuItem(value: 'Completed', child: Text('Thành công', style: TextStyle(fontSize: 14))),
                                          DropdownMenuItem(value: 'Cancelled', child: Text('Trả hàng', style: TextStyle(fontSize: 14))),
                                        ],
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            controller.updateOrder(maDonHang, newValue);
                                          }
                                        },
                                      ),
                                    );
                                  });
                                },
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
                        stream: getOrder(),
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
                              stream: getProduct(),
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
                                      stream: getCTDonHangs(maDonHang),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          print("không có dữ liệu!");
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
                                                      DataCell(Text(priceFormat((product.giaTien - product.giaTien * product.KhuyenMai ~/ 100)),
                                                          style: const TextStyle(fontSize: 25))),
                                                      DataCell(Text(
                                                          priceFormat(
                                                              (product.giaTien - product.giaTien * product.KhuyenMai ~/ 100) * ctDonHang.soLuong),
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
                    Text('Tổng thành tiền: ${priceFormat(orderdata.tongTien)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm Mã Đơn Hàng',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm Người Đặt',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm Trạng Thái',
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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<OrdersModel>>(
                stream: getOrder(),
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
                      stream: fetchProfilesStream(),
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
                              child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: MediaQuery.of(context).size.width / 20,
                              dividerThickness: 0,
                              dataRowColor: MaterialStateProperty.all(Colors.transparent),
                              columns: const [
                                DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Mã Đơn Hàng', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Tên Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Ngày Đặt', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Trạng Thái', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                    color: MaterialStateColor.resolveWith((states) => index.isEven ? Colors.white : TColros.grey_wheat),
                                    cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(order.id)),
                                      DataCell(Text(profile.HoTen ?? 'Không có tên')),
                                      DataCell(Text(DateFormat('dd-MM-yyyy, hh:mm a').format(order.ngayTaoDon.toDate()))),
                                      DataCell(Text(
                                        order.isBeingShipped == true
                                            ? "Đã Hủy"
                                            : order.isShipped == true
                                                ? "Đang vận chuyển"
                                                : order.isCompleted == true
                                                    ? "Thành công"
                                                    : order.isCancelled == true
                                                        ? "Trả hàng"
                                                        : order.isPaid == true
                                                            ? "Chờ xác nhận"
                                                            : "",
                                        style: TextStyle(
                                          color: order.isBeingShipped == true
                                              ? Colors.red
                                              : order.isShipped == true
                                                  ? Colors.orange
                                                  : order.isCompleted == true
                                                      ? Colors.green
                                                      : order.isCancelled == true
                                                          ? Colors.purple
                                                          : order.isPaid == true
                                                              ? Colors.blue
                                                              : Colors.black,
                                        ),
                                      )),
                                      DataCell(ElevatedButton(
                                        onPressed: () {
                                          showOrderDetails(context, order, profile, order.id);
                                        },
                                        child: const Text("Chi tiết"),
                                      )),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ));
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
