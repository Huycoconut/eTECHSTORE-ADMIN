import 'package:etech_store_admin/module/order/controller/order_manage_controller.dart';
import 'package:etech_store_admin/module/order/model/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownButtonChangeWidget extends StatefulWidget {
  DropDownButtonChangeWidget({super.key, required this.maDonHang, required this.order});
  String maDonHang;
  OrdersModel order;
  @override
  State<DropDownButtonChangeWidget> createState() => _DropDownButtonChangeWidgetState();
}

class _DropDownButtonChangeWidgetState extends State<DropDownButtonChangeWidget> {
  OrderManageController controller = Get.put(OrderManageController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.fetchOrder(widget.maDonHang),
      builder: (context, snapshot) {
        return Container(
          height: 23,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(border: Border.all(width: .5, color: const Color.fromARGB(255, 212, 212, 212))),
          child: Obx(
            () => DropdownButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 25,
              underline: const SizedBox(),
              value: controller.getSelectedStatus(),
              items: const [
                DropdownMenuItem(value: 'Paid', child: Text('Chờ xác nhận', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(value: 'Being Shipped', child: Text('Đã hủy', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(value: 'Shipped', child: Text('Đang vận chuyển', style: TextStyle(fontSize: 14))),
                DropdownMenuItem(value: 'Completed', child: Text('Thành công', style: TextStyle(fontSize: 14))),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    controller.updateOrder(widget.maDonHang, newValue);
                    controller.updateOrderStatus(
                        isBeingShipped: widget.order.isBeingShipped,
                        isCompleted: widget.order.isCompleted,
                        isShipped: widget.order.isShipped,
                        orderId: widget.order.id,
                        uid: widget.order.maKhachHang);
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }
}
