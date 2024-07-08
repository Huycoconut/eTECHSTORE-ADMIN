import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/discount/model/discount_model.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class DiscountController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController nameDisCountController = TextEditingController();
  TextEditingController startDisCountController = TextEditingController();
  TextEditingController endDisCountController = TextEditingController();
  TextEditingController persentDisCountController = TextEditingController();

  TextEditingController newNameDisCountController = TextEditingController();
  TextEditingController newStartDisCountController = TextEditingController();
  TextEditingController newEndDisCountController = TextEditingController();
  TextEditingController newPersentDisCountController = TextEditingController();

  var selectedProductId = <String>[].obs;

  DateTime? startDate;
  DateTime? endDate;

  final discount = <DiscountModel>[].obs;
  var itemsPerPage = 10.obs;
  var allDiscount = <DiscountModel>[].obs;
  var currentPage = 1.obs;
  var allProduct = <ProductModel>[].obs;
  final product = <ProductModel>[].obs;
 
  var selectedDate = DateTime.now().obs;
  RxBool nameDisCount = false.obs;
  RxBool persenDisCount = false.obs;

  void updatePage(int page) {
    currentPage.value = page;
  }

  @override
  void onInit() {
    getProduct();
    getDiscount();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      updateDiscounts();
    });
    super.onInit();
  }

 void initiDateTime(DiscountModel disCount) {
     startDate = disCount.ngayBD.toDate();
    endDate = disCount.ngayKT.toDate();
  }

  void clearValues() {
    selectedProductId.clear();
 
    selectedDate.value = DateTime.now();
    nameDisCount.value = false;
    persenDisCount.value = false;
    newNameDisCountController.clear();
    newStartDisCountController.clear();
    newEndDisCountController.clear();
    newPersentDisCountController.clear();
  }

  Stream<List<DiscountModel>> getDiscount() {
    return firestore.collection('KhuyenMai').where('TrangThai', isEqualTo: 1).snapshots().map((query) {
      discount.value = query.docs.map((doc) => DiscountModel.fromJson(doc.data())).toList();
      allDiscount.value = discount;
      return discount;
    });
  }

  Stream<List<ProductModel>> getProduct() {
    return firestore.collection('SanPham').where('TrangThai', isEqualTo: true).where('KhuyenMai', isEqualTo: 0).snapshots().map((query) {
      product.value = query.docs.map((doc) => ProductModel.fromFirestore(doc.data())).toList();
      allProduct.value = product;
      return product;
    });
  }

  Stream<List<ProductModel>> getProductEdit() {
    return firestore.collection('SanPham').where('TrangThai', isEqualTo: true).snapshots().map((query) {
      product.value = query.docs.map((doc) => ProductModel.fromFirestore(doc.data())).toList();
      allProduct.value = product;
      return product;
    });
  }

  String generateId() {
    return firestore.collection('KhuyenMai').doc().id;
  }

  Future<void> saveDiscount() async {
    try {
      if (newNameDisCountController.text.isEmpty ||
          newPersentDisCountController.text.isEmpty ||
          startDate == null ||
          endDate == null ||
          selectedProductId.value.isEmpty || startDate!.isAfter(endDate!)) {
        Future.delayed(const Duration(seconds: 2),
            () => TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại", onDismissed: () => const Text("")));
      } else {
        DiscountModel discount = DiscountModel(
          id: generateId(),
          ngayBD: Timestamp.fromDate(startDate!),
          ngayKT: Timestamp.fromDate(endDate!),
          phanTramKhuyenMai: int.parse(newPersentDisCountController.text),
          ten: newNameDisCountController.text,
          dsSanPham: selectedProductId.toList(),
          trangThai: 1,
        );

        FirebaseFirestore.instance.collection('KhuyenMai').add({
          'id': generateId(),
          'NgayBD': discount.ngayBD,
          'NgayKT': discount.ngayKT,
          'PhanTramKhuyenMai': discount.phanTramKhuyenMai,
          'Ten': discount.ten,
          'DSSanPham': discount.dsSanPham,
          'TrangThai': discount.trangThai
        }).then((value) {
          Future.delayed(const Duration(seconds: 2),
              () => TLoaders.showSuccessPopup(title: "Thông Báo", description: "Thêm thành công", onDismissed: () => const Text("")));
          _updateProductsWithDiscount(discount);
          clearValues();
        }).catchError((error) {
          Future.delayed(const Duration(seconds: 2),
              () => TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại", onDismissed: () => const Text("")));
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2),
          () => TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại", onDismissed: () => const Text("")));
    } finally {
      FullScreenLoader.openLoadingDialog("Đang xử lý", ImageKey.loadingAnimation);
    }
  }

  Future<void> _updateProductsWithDiscount(DiscountModel discount) async {
    FirebaseFirestore.instance.collection('SanPham').where(FieldPath.documentId, whereIn: discount.dsSanPham).get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({
          'KhuyenMai': discount.phanTramKhuyenMai,
        });
      }
    }).catchError((error) {
      Future.delayed(const Duration(seconds: 2),
          () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));
    });
  }

  Future<void> updateDiscounts() async {
    try {
      final now = DateTime.now();
      final expiredDiscounts =
          await FirebaseFirestore.instance.collection('KhuyenMai').where('NgayKT', isLessThanOrEqualTo: Timestamp.fromDate(now)).get();

      for (var discountDoc in expiredDiscounts.docs) {
        var discountData = discountDoc.data();

        List<String> dsSanPham;
        try {
          dsSanPham = List<String>.from(discountData['DSSanPham']);
        } catch (e) {
          print('Error converting dsSanPham: $e');
          continue;
        }

        await discountDoc.reference.update({
          'PhanTramKhuyenMai': 0,
        }).catchError((error) {
          Future.delayed(const Duration(seconds: 2),
              () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));
        });

        await FirebaseFirestore.instance.collection('SanPham').where(FieldPath.documentId, whereIn: dsSanPham).get().then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({
              'KhuyenMai': 0,
            }).catchError((error) {
              Future.delayed(const Duration(seconds: 2),
                  () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));
            });
          }
        }).catchError((error) {
          Future.delayed(const Duration(seconds: 2),
              () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2),
          () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));
    }
  }

  Future<void> updateStatusDisCount(String id, DiscountModel disCount) async {
    try {
      await firestore.collection('KhuyenMai').doc(id).update({
        'TrangThai': 0,
        'PhanTramKhuyenMai': 0,
      });
      TLoaders.successPopup(title: "Thông Báo", description: "Lưu Thành Công");
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lưu Thất Bại");
    }
  }

  void initializeProduct(DiscountModel disCount) {
    nameDisCountController = TextEditingController(text: disCount.ten);
    persentDisCountController = TextEditingController(text: "${disCount.phanTramKhuyenMai.toInt()}%");
  }

  Future<void> updateDisCount(String id, DiscountModel discount) async {
    try {
      if (startDate!.isAfter(endDate!)) {
        TLoaders.showErrorPopup(title: "Thông Báo", description: "Ngày bắt đầu không thể sau ngày kết thúc");
      } else {
        await firestore.collection('KhuyenMai').doc(id).update({
          'NgayBD': Timestamp.fromDate(startDate!) ?? discount.ngayBD,
          'NgayKT': Timestamp.fromDate(endDate!) ?? discount.ngayKT,
          'PhanTramKhuyenMai': persentDisCountController.text.isNotEmpty ? int.parse(persentDisCountController.text) : discount.phanTramKhuyenMai,
          'Ten': nameDisCountController.text ?? discount.ten,
        });

        await FirebaseFirestore.instance.collection('SanPham').where(FieldPath.documentId, whereIn: selectedProductId).get().then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({
              'KhuyenMai': persentDisCountController.text.isNotEmpty ? int.parse(persentDisCountController.text) : discount.phanTramKhuyenMai,
            });
          }
        }).catchError((error) {
          Future.delayed(const Duration(seconds: 2),
              () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));
        });

        TLoaders.successPopup(title: "Thông Báo", description: "Lưu Thành Công");
      }

      Navigator.pop(Get.context!);
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lưu Thất Bại");
    }
  }

 
}
