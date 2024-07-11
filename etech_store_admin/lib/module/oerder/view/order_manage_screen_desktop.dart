import 'package:etech_store_admin/module/oerder/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/oerder/model/orders_model.dart';
import 'package:etech_store_admin/module/oerder/view/widget/show_dialog_widet.dart';
import 'package:etech_store_admin/module/product/view/widget/pagination_product_widget.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../profile/model/profile_model.dart';

class OrderManageDesktopScreen extends StatelessWidget {
  const OrderManageDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderManageController controller = Get.put(OrderManageController());

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        title: const Text('Quản Lý Đơn Hàng'),
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
                    onChanged: (value) {
                      controller.searchOrderId.value = value;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm Người Đặt',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.searchCustomerName.value = value;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm Trạng Thái',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.searchStatus.value = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
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

                          return Obx(() {
                            List<OrdersModel> filteredOrders = orders.where((order) {
                              final customer = profiles.firstWhere((profile) => profile.uid == order.maKhachHang,
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
                              final status = order.isBeingShipped
                                  ? "Đã Hủy"
                                  : order.isShipped
                                      ? "Đang vận chuyển"
                                      : order.isCompleted
                                          ? "Hoàn thành"
                                          : "Chờ xác nhận";

                              return order.id.toLowerCase().contains(controller.searchOrderId.value.toLowerCase()) &&
                                  customer.HoTen.toLowerCase().contains(controller.searchCustomerName.value.toLowerCase()) &&
                                  status.toLowerCase().contains(controller.searchStatus.value.toLowerCase());
                            }).toList();

                            if (controller.searchCustomerName.value.isEmpty &&
                                controller.searchOrderId.value.isEmpty &&
                                controller.searchStatus.value.isEmpty) {
                              filteredOrders = controller.lstProduct;
                            }

                            int startIndex = (controller.currentPage.value - 1) * controller.itemsPerPage.value;
                            int endIndex = startIndex + controller.itemsPerPage.value;
                            List<OrdersModel> paginatedOrders = filteredOrders.sublist(startIndex, endIndex.clamp(0, filteredOrders.length)).toSet().toList();

                            return SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: DataTable(
                                        dataRowHeight: 70,
                                        horizontalMargin: 50,
                                        headingRowHeight: 30,
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
                                          paginatedOrders.length,
                                          (index) {
                                            final order = paginatedOrders[index];
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
                                                              : "Chờ xác nhận",
                                                  style: TextStyle(
                                                      color: order.isBeingShipped == true
                                                          ? Colors.red
                                                          : order.isShipped == true
                                                              ? Colors.orange
                                                              : order.isCompleted == true
                                                                  ? Colors.green
                                                                  : Colors.blue),
                                                )),
                                                DataCell(ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                      backgroundColor: TColros.purple_line),
                                                  onPressed: () {
                                                    ShowDiaLogOrderDetail.showOrderDetails(context, order, profile, order.id);
                                                  },
                                                  child: const Text(
                                                    "Chi tiết",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                )),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Pagination(
                                      currentPage: controller.currentPage.value,
                                      itemsPerPage: controller.itemsPerPage.value,
                                      totalItems: filteredOrders.length,
                                      onPageChanged: (page) => controller.updatePage(page),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
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
