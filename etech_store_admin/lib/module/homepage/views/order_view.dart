import 'package:etech_store_admin/module/oerder_manage/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/oerder_manage/model/orders_model.dart';
import 'package:etech_store_admin/module/oerder_manage/view/widget/show_dialog_widet.dart';
import 'package:etech_store_admin/module/product/view/widget/pagination_product_widget.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget orderView() {
  OrderManageController controller = Get.put(OrderManageController());
  return StreamBuilder<List<OrdersModel>>(
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
                          DiaChi: "", Email: "", HinhDaiDien: "", HoTen: "", Password: "", Quyen: true, SoDienThoai: 1234567, TrangThai: 1, uid: ""));
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

                if (controller.searchCustomerName.value.isEmpty && controller.searchOrderId.value.isEmpty && controller.searchStatus.value.isEmpty) {
                  filteredOrders = controller.lstProduct;
                }

                int startIndex = (controller.currentPage.value - 1) * controller.itemsPerPage.value;
                int endIndex = startIndex + controller.itemsPerPage.value;
                List<OrdersModel> paginatedOrders = filteredOrders.sublist(startIndex, endIndex.clamp(0, filteredOrders.length)).toSet().toList();

                return SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          child: DataTable(
                            dataRowMaxHeight: double.infinity,
                            dividerThickness: 0.5,
                            dataRowColor: MaterialStateProperty.all(Colors.transparent),
                            columns: const [
                              DataColumn(label: Text('Mã Đơn Hàng', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                    DataCell(Text(order.id)),
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
  );
}
