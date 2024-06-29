import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/report/models/order_model.dart';
import 'package:etech_store_admin/module/wishlist/controllers/wishlist_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final adminID = FirebaseAuth.instance.currentUser!.uid;
  final subController = Get.put(WishlistController());
  RxList<OrderModel> listOrder = <OrderModel>[].obs;

  RxList<OrderModel> listOrderByTime = <OrderModel>[].obs;
  RxString userIDSelected = ''.obs;
  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    db.collection('DonHang').snapshots().listen((orders) {
      listOrder.clear();
      orders.docs.forEach((order) {
        listOrder.add(OrderModel.fromSnapshot(order));
      });
    });
  }

  void fetchOrdersByTime(int startDay, int endDay, int month, int year) {
    listOrderByTime.clear();
    final startTimestamp = Timestamp.fromDate(DateTime(year, month, startDay));
    final endTimestamp = Timestamp.fromDate(DateTime(year, month, endDay));
    for (var order in listOrder) {
      final comparisonResult1 = order.NgayTaoDon.compareTo(startTimestamp);
      final comparisonResult2 = order.NgayTaoDon.compareTo(endTimestamp);
      if (comparisonResult1 > 0 && comparisonResult2 < 0 && order.isCompleted) {
        listOrderByTime.add(order);
      }
    }
  }

  int getTotalIncome(int month, int year) {
    var totalIcome = 0;
    final startTimestamp = Timestamp.fromDate(DateTime(year, month, 0));
    final endTimestamp = Timestamp.fromDate(DateTime(year, month, 32));
    for (var order in listOrder) {
      final comparisonResult1 = order.NgayTaoDon.compareTo(startTimestamp);
      final comparisonResult2 = order.NgayTaoDon.compareTo(endTimestamp);
      if (comparisonResult1 > 0 && comparisonResult2 < 0 && order.isCompleted) {
        totalIcome += order.TongTien;
      }
    }
    return totalIcome;
  }

  double getIncome1to7(int month, int year) {
    var income = 0;
    fetchOrdersByTime(0, 7, month, year);
    for (var order in listOrderByTime) {
      income += order.TongTien;
    }
    return income.toDouble();
  }

  double getIncome8to14(int month, int year) {
    var income = 0;
    fetchOrdersByTime(7, 15, month, year);
    for (var order in listOrderByTime) {
      income += order.TongTien;
    }
    return income.toDouble();
  }

  double getIncome15to21(int month, int year) {
    var income = 0;
    fetchOrdersByTime(15, 22, month, year);
    for (var order in listOrderByTime) {
      income += order.TongTien;
    }
    return income.toDouble();
  }

  double getIncome22to28(int month, int year) {
    var income = 0;
    fetchOrdersByTime(22, 29, month, year);
    for (var order in listOrderByTime) {
      income += order.TongTien;
    }
    return income.toDouble();
  }

  double getIncome29toEnd(int month, int year) {
    var income = 0;
    final now = DateTime.now();
    fetchOrdersByTime(
        29, DateTime(now.year, now.month + 1, 0).day, month, year);
    for (var order in listOrderByTime) {
      income += order.TongTien;
    }
    return income.toDouble();
  }

  int getExpectedEarnings() {
    int totalEarnings = 0;
    for (var order in listOrder) {
      if (!order.isCompleted && !order.isCancelled) {
        totalEarnings += order.TongTien;
      }
    }
    return totalEarnings;
  }
}
