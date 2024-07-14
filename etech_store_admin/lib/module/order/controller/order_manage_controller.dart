import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/order/model/detail_orders.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:etech_store_admin/services/noti_service.dart';
import 'package:get/get.dart';

import '../model/orders_model.dart';

class OrderManageController extends GetxController {
  OrderManageController get instance => Get.find();
  var searchOrderId = ''.obs;
  var searchCustomerName = ''.obs;
  var searchStatus = ''.obs;
  var itemsPerPage = 15.obs;
  var lstProduct = <OrdersModel>[].obs;
  var currentPage = 1.obs;
  var order = OrdersModel(
    id: '',
    ngayTaoDon: Timestamp.now(),
    maKhachHang: '',
    tongTien: 0,
    isPaid: false,
    isBeingShipped: false,
    isShipped: false,
    isCompleted: false,
  ).obs;

  void updatePage(int page) {
    currentPage.value = page;
  }

  Future<void> fetchOrder(String orderId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('DonHang').doc(orderId).get();
    order.value = OrdersModel.fromFirestore(doc);
  }

  void updateOrderStatus(String orderId, bool isBeingShipped, bool isShipped, bool isCompleted, String uid) async {
    if (isBeingShipped && isShipped && isCompleted) {
      await Contants.sendNotificationToUser(uid, "Đang chờ xác nhận", "Đơn hàng của bạn đang chờ xác nhận.");
    } else if (!isShipped) {
      await Contants.sendNotificationToUser(uid, "Đang vận chuyển", "Đơn hàng của bạn đang được vận chuyển.");
    } else if (!isCompleted) {
      await Contants.sendNotificationToUser(uid, "Giao thành công", "Đơn hàng của bạn đã giao thành công.");
    }
  }

  Future<void> updateOrder(String orderId, String newStatus) async {
    order.value.updateState(newStatus);
    await FirebaseFirestore.instance.collection('DonHang').doc(orderId).update(order.value.toJson());
  }

  String getSelectedStatus() {
    if (order.value.isBeingShipped) return 'Being Shipped';
    if (order.value.isShipped) return 'Shipped';
    if (order.value.isCompleted) return 'Completed';
    return 'Paid';
  }

  Stream<List<OrdersModel>> getOrder() {
    return FirebaseFirestore.instance.collection('DonHang').orderBy('NgayTaoDon', descending: true).snapshots().map((query) {
      List<OrdersModel> orders = query.docs.map((doc) => OrdersModel.fromFirestore(doc)).toSet().toList();
      lstProduct.value = orders;
      return orders;
    });
  }

  Stream<List<ProfileModel>> fetchProfilesStream() {
    return FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ProfileModel.fromJson(doc.data())).toList());
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
}
