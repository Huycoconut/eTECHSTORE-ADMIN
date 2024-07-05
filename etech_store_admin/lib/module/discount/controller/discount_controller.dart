import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/discount/model/discount_model.dart';
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

  final discount = <DiscountModel>[].obs;
  var itemsPerPage = 10.obs;
  var allDiscount = <DiscountModel>[].obs;
  var currentPage = 1.obs;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  var selectedDate = DateTime.now().obs;
  RxBool nameDisCount = false.obs;
  RxBool persenDisCount = false.obs;

  void updatePage(int page) {
    currentPage.value = page;
  }

  Stream<List<DiscountModel>> getDiscount() {
    return firestore.collection('KhuyenMai').orderBy('NgayBD', descending: true).snapshots().map((query) {
      discount.value = query.docs.map((doc) => DiscountModel.fromJson(doc.data())).toList();
      allDiscount.value = discount;
      return discount;
    });
  }

  Future<void> updateStatusDisCount(String id, DiscountModel disCount) async {
    try {
      await firestore.collection('KhuyenMai').doc(id).update({
        'TrangThai': 0,
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
      if (selectedStartDate!.isAfter(selectedEndDate!)) {
        TLoaders.showErrorPopup(title: "Thông Báo", description: "Ngày bắt đầu không thể sau ngày kết thúc");
      } else {
        await firestore.collection('KhuyenMai').doc(id).update({
          'NgayBD': selectedStartDate != null ? Timestamp.fromDate(selectedStartDate!) : discount.ngayBD,
          'NgayKT': selectedEndDate != null ? Timestamp.fromDate(selectedEndDate!) : discount.ngayKT,
          'PhanTramKhuyenMai': persentDisCountController.text.isNotEmpty ? int.parse(persentDisCountController.text) : discount.phanTramKhuyenMai,
          'Ten': nameDisCountController.text ?? discount.ten,
        });
        TLoaders.successPopup(title: "Thông Báo", description: "Lưu Thành Công");
      }

      Navigator.pop(Get.context!);
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lưu Thất Bại");
    }
  }

  Future<void> showDatePicker(BuildContext context, DiscountModel discount) async {
    try {
      selectedStartDate = await showDatePickerDialog(
        centerLeadingDate: true,
        context: context,
        initialDate: selectedDate.value,
        minDate: DateTime(2024),
        maxDate: DateTime(2100),
      );

      selectedEndDate = await showDatePickerDialog(
        centerLeadingDate: true,
        context: context,
        initialDate: selectedEndDate,
        minDate: selectedStartDate!,
        maxDate: DateTime(2100),
      );

      if (selectedStartDate!.isAfter(selectedEndDate!)) {
        TLoaders.showErrorPopup(title: "Thông Báo", description: "Ngày bắt đầu không thể sau ngày kết thúc");
        return;
      }
    } catch (e) {
      print("Error showing date picker: $e");
    }
  }
}
