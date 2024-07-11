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

  RxList<String> selectedProductId = <String>[].obs;
  List<String> originalProductIds = [];

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
      updateDiscountsTimeOut();
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
    setTimeNow();
  }

  void setTimeNow() {
    startDate = DateTime.now();
    endDate = DateTime.now();
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

  Future<void> removeProductInDisCount(DiscountModel disCount, int index, String id) async {
    try {
      disCount.dsSanPham.removeAt(index);
      await firestore.collection("KhuyenMai").doc(disCount.id).update({'DSSanPham': disCount.dsSanPham});
      await firestore.collection('SanPham').where('id', isEqualTo: id).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({
            'KhuyenMai': 0,
          });
        }
      });
      update();
    } catch (e) {
      print("Error: $e");
    }
  }



  Future<void> saveDiscount() async {
    String id = firestore.collection('KhuyenMai').doc().id;
    try {
      if (newNameDisCountController.text.isEmpty ||
          newPersentDisCountController.text.isEmpty ||
          startDate == null ||
          endDate == null ||
          selectedProductId.value.isEmpty ||
          startDate!.isAfter(endDate!)) {
        Future.delayed(const Duration(seconds: 2),
            () => TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại", onDismissed: () => const Text("")));
      } else {
        DiscountModel discount = DiscountModel(
          id: id,
          ngayBD: Timestamp.fromDate(startDate!),
          ngayKT: Timestamp.fromDate(endDate!),
          phanTramKhuyenMai: int.parse(newPersentDisCountController.text),
          ten: newNameDisCountController.text,
          dsSanPham: selectedProductId.toList(),
          trangThai: 1,
        );

        firestore.collection("KhuyenMai").doc(id).set(discount.toJson());
        Future.delayed(const Duration(seconds: 2),
            () => TLoaders.showSuccessPopup(title: "Thông Báo", description: "Thêm thành công", onDismissed: () => const Text("")));
        _updateProductsWithDiscount(discount);
        clearValues();
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

  Future<void> updateDiscountsTimeOut() async {
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
          Future.delayed(const Duration(seconds: 2),
              () => TLoaders.showErrorPopup(title: "Thông báo", description: "Cập nhật khuyến mãi thất bại", onDismissed: () => const Text("")));

          continue;
        }

        await discountDoc.reference.update({'PhanTramKhuyenMai': 0});

        await FirebaseFirestore.instance.collection('SanPham').where(FieldPath.documentId, whereIn: dsSanPham).get().then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({'KhuyenMai': 0});
          }
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
      firestore.collection("SanPham").get().then((value) {
        for (var doc in value.docs) {
          if (disCount.dsSanPham.contains(doc.data()['id'])) {
            firestore.collection("SanPham").doc(doc.id).update({"KhuyenMai": 0});
          }
        }
      });
      TLoaders.successPopup(title: "Thông Báo", description: "Lưu Thành Công");
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lưu Thất Bại");
    }
  }

  void initializeProduct(DiscountModel disCount) {
    nameDisCountController = TextEditingController(text: disCount.ten);
    persentDisCountController = TextEditingController(text: "${disCount.phanTramKhuyenMai.toInt()}");
  }

  Future<void> saveSelectedProducts(DiscountModel discount) async {
    List<String> updatedProductIds = originalProductIds;

    for (String id in selectedProductId) {
      if (!updatedProductIds.contains(id)) {
        updatedProductIds.add(id);
      }
    }
/* 
    for (String id in originalProductIds) {
      if (!selectedProductId.contains(id)) {
        updatedProductIds.remove(id);
      }
    }
 */
    discount.dsSanPham = updatedProductIds;
    await firestore.collection("KhuyenMai").doc(discount.id).update({'DSSanPham': discount.dsSanPham});
    update();
  }

Future<void> updateDisCount(String id, DiscountModel discount) async {
  try {
    if (startDate != null && endDate != null && startDate!.isAfter(endDate!)) {
      Future.delayed(
        const Duration(seconds: 2),
        () => TLoaders.showErrorPopup(title: "Thông Báo", description: "Ngày bắt đầu không thể sau ngày kết thúc"),
      );
      return;
    }

     Map<String, dynamic> updateData = {
      'NgayBD': startDate != null ? Timestamp.fromDate(startDate!) : discount.ngayBD,
      'NgayKT': endDate != null ? Timestamp.fromDate(endDate!) : discount.ngayKT,
      'PhanTramKhuyenMai': persentDisCountController.text.isNotEmpty ? int.parse(persentDisCountController.text) : discount.phanTramKhuyenMai,
      'Ten': nameDisCountController.text.isNotEmpty ? nameDisCountController.text : discount.ten,
     };

     await firestore.collection('KhuyenMai').doc(id).update(updateData);

     if (selectedProductId.isNotEmpty) {
      await firestore.collection('SanPham').where(FieldPath.documentId, whereIn: selectedProductId).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({
            'KhuyenMai': persentDisCountController.text.isNotEmpty ? int.parse(persentDisCountController.text) : discount.phanTramKhuyenMai,
          });
        }
      });
    }

     await saveSelectedProducts(discount);

     Future.delayed(
      const Duration(seconds: 2),
      () => TLoaders.showSuccessPopup(title: "Thông Báo", description: "Lưu Thành Công"),
    );

  } catch (e) {
    print(e);

     Future.delayed(
      const Duration(seconds: 2),
      () => TLoaders.showErrorPopup(title: "Thông Báo", description: "Lưu Thất Bại"),
    );
  } finally {
     FullScreenLoader.openLoadingDialog("", ImageKey.loadingAnimation);
  }

}


}
