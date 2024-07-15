import 'package:etech_store_admin/module/order/model/orders_model.dart';
import 'package:flutter/material.dart';

class StatucOrder extends StatefulWidget {
  StatucOrder({super.key, required this.orderdata});
  OrdersModel orderdata;
  @override
  State<StatucOrder> createState() => _StatucOrderState();
}

class _StatucOrderState extends State<StatucOrder> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.orderdata.isBeingShipped == true
          ? "Đã Hủy"
          : widget.orderdata.isShipped == true
              ? "Đang vận chuyển"
              : widget.orderdata.isCompleted == true
                  ? "Hoàn thành"
                  : "Chờ xác nhận",
      style: TextStyle(
        color: widget.orderdata.isBeingShipped == true
            ? Colors.red
            : widget.orderdata.isShipped == true
                ? Colors.orange
                : widget.orderdata.isCompleted == true
                    ? Colors.green
                    : Colors.blue,
      ),
    );
  }
}
