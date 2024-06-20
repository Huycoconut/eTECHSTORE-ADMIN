import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/orders_model.dart';

class OrderManageController extends GetxController {
  OrderManageController get instance => Get.find();

  RxString selectedStatus = 'Chờ xác nhận'.obs;
  List<String> listStatus = ['Chờ xác nhận', 'Đang giao', 'Thành công', 'Đã hủy', 'Trả hàng'].obs;

  var order = OrdersModel(
    id: '',
    ngayTaoDon: Timestamp.now(),
    maKhachHang: '',
    tongTien: 0,
    tongDuocGiam: 0,
    isPaid: false,
    isBeingShipped: false,
    isShipped: false,
    isCompleted: false,
    isCancelled: false,
  ).obs;

  Future<void> fetchOrder(String orderId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('DonHang').doc(orderId).get();
    order.value = OrdersModel.fromFirestore(doc);
  }

  Future<void> updateOrder(String orderId, String newStatus) async {
    order.value.updateState(newStatus);
    await FirebaseFirestore.instance.collection('DonHang').doc(orderId).update(order.value.toJson());
  }

  String getSelectedStatus() {
    if (order.value.isPaid) return 'Paid';
    if (order.value.isBeingShipped) return 'Being Shipped';
    if (order.value.isShipped) return 'Shipped';
    if (order.value.isCompleted) return 'Completed';
    if (order.value.isCancelled) return 'Cancelled';
    return 'None';
  }
}
