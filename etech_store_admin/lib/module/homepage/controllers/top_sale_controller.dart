import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/oerder_manage/model/detail_orders.dart';
import 'package:etech_store_admin/module/report/models/order_model.dart';
import 'package:etech_store_admin/module/report/models/product_model.dart';
import 'package:get/get.dart';

class TopSaleController extends GetxController {
  static TopSaleController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  RxList<ProductModel> listProducts = <ProductModel>[].obs;
  RxList<DetailOrders> listDetail = <DetailOrders>[].obs;
  RxList<OrderModel> listOrder = <OrderModel>[].obs;
  @override
  void onInit() {
    fetchOrder();
    super.onInit();
  }

  Future<void> fetchOrder() async {
    db.collection('DonHang').snapshots().listen((orders) {
      listOrder.clear();
      orders.docs.forEach((order) {
        listOrder.add(OrderModel.fromSnapshot(order));
      });
    });
  }

  Future<void> fetchData() async {
    db.collection('SanPham').snapshots().listen((users) {
      listProducts.clear();
      users.docs.forEach((user) {
        listProducts.add(ProductModel.fromSnapshot(user));
      });
    });
    db.collection('CTDonHang').snapshots().listen((detailOrder) {
      listDetail.clear();
      detailOrder.docs.forEach((detail) {
        listDetail.add(DetailOrders.fromSnapshot(detail));
      });
    });
  }

  Future<void> getQuantitySale() async {
    fetchData();
    for (var product in listProducts) {
      for (var detail in listDetail) {
        if (getStatusOrder(detail.maDonHang)) {
          if (product.id == detail.maMauSanPham['MaSanPham']) {
            product.quantity += detail.soLuong;
          }
        }
      }
    }
    listProducts.sort((a, b) => b.quantity.compareTo(a.quantity));
  }

  getStatusOrder(String detailID) {
    for (var order in listOrder) {
      if (detailID == order.id && order.isCompleted) {
        return true;
      }
    }
    return false;
  }
}
