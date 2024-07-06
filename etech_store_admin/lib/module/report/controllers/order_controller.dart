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

  Future<void> getOrderByMonth(int month, int year) async {
    final startTimestamp = Timestamp.fromDate(DateTime(year, month, 0));
    final endTimestamp = Timestamp.fromDate(DateTime(year, month, 32));
    for (var order in listOrder) {
      final comparisonResult1 = order.NgayTaoDon.compareTo(startTimestamp);
      final comparisonResult2 = order.NgayTaoDon.compareTo(endTimestamp);
      if (comparisonResult1 > 0 && comparisonResult2 < 0 && order.isCompleted) {
        listOrderByTime.add(order);
      }
    }
  }

  int fetchOrdersByTime(int day, int month, int year) {
    int totalIncome = 0;
    final startTimestamp = Timestamp.fromDate(DateTime(year, month, day));
    final endTimestamp = Timestamp.fromDate(DateTime(year, month, day + 2));
    for (var order in listOrder) {
      final comparisonResult1 = order.NgayTaoDon.compareTo(startTimestamp);
      final comparisonResult2 = order.NgayTaoDon.compareTo(endTimestamp);
      if (comparisonResult1 > 0 && comparisonResult2 < 0 && order.isCompleted) {
        totalIncome += order.TongTien;
      }
    }
    return totalIncome;
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

  int getExpectedEarnings() {
    int totalEarnings = 0;
    for (var order in listOrder) {
      if (!order.isCompleted && !order.isCancelled) {
        totalEarnings += order.TongTien;
      }
    }
    return totalEarnings;
  }

  double getAverageDailyIncome() {
    final DateTime firstDate = DateTime(2024, 7, 0);
    final DateTime now = DateTime.now();
    Duration difference = now.difference(firstDate);
    double averageDailyIncome = 0;
    for (var order in listOrder) {
      if (order.isCompleted) {
        averageDailyIncome += order.TongTien;
      }
    }
    averageDailyIncome /= difference.inDays;
    return averageDailyIncome;
  }

  double getTheIncomeDifferenceRatio() {
    final DateTime now = DateTime.now();
    double totalIncomeToday = 0;
    for (var order in listOrder) {
      if (order.isCompleted &&
          order.NgayTaoDon.toDate()
              .isAfter(DateTime(now.year, now.month, now.day))) {
        totalIncomeToday += order.TongTien;
      }
    }
    double theIncomeDifferenceRatio =
        ((totalIncomeToday - getAverageDailyIncome()) /
                getAverageDailyIncome()) *
            100;
    return theIncomeDifferenceRatio;
  }
}
