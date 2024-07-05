import 'package:etech_store_admin/module/product/model/product_sample_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSampleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ProductSampleModel> sampleProduct = <ProductSampleModel>[].obs;
  RxList<Map<String, TextEditingController>> variantColors = <Map<String, TextEditingController>>[].obs;
  RxList<Map<String, TextEditingController>> variantConfigs = <Map<String, TextEditingController>>[].obs;
  RxList<Map<String, TextEditingController>> variantPrices = <Map<String, TextEditingController>>[].obs;
  RxBool showActribute = false.obs;
  RxBool addAtribute = false.obs;
  late RxInt maxLen = 0.obs;

  var originalGiaTienMap = <String, int>{}.obs; // Lưu trữ giá trị gốc của giaTien

  RxList<TextEditingController> mauSacControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> cauHinhControllers = <TextEditingController>[].obs;
  TextEditingController newPriceController = TextEditingController();

  void changeAtribute() {
    showActribute.value = !showActribute.value;
  }

  void addAtributeProduct() {
    addAtribute.value = !addAtribute.value;
  }

  void clearProductDetails() {
    originalGiaTienMap.clear();
  }

  var selectedColorIndex = 0.obs;
  var selectedConfigIndex = 0.obs;
  var displayedPrice = ''.obs;
  var currentPrice = 0.obs;

  void setSelectedColorIndex(int index, ProductSampleModel sample) {
    selectedColorIndex.value = index;
    updatePrice(sample); // Cập nhật giá tiền khi chọn màu sắc
  }

  void setSelectedConfigIndex(int index, ProductSampleModel sample) {
    selectedConfigIndex.value = index;
    updatePrice(sample); // Cập nhật giá tiền khi chọn cấu hình
  }

  void updatePrice(ProductSampleModel sample) {
    final colorIndex = selectedColorIndex.value;
    final configIndex = selectedConfigIndex.value;

    // Tính chỉ số của giá tiền dựa trên chỉ số màu sắc và cấu hình
    final index = colorIndex * sample.cauHinh.length + configIndex;
    print('Color Index: $colorIndex, Config Index: $configIndex, Calculated Index: $index'); // Debugging line

    if (index >= 0 && index < sample.giaTien.length) {
      displayedPrice.value = sample.giaTien[index].toString();
    } else {
      displayedPrice.value = 'Không có giá'; // Thêm thông báo nếu không có giá cho sự kết hợp này
    }
  }

  Future<void> updatePriceInFirestore(int newPrice, ProductSampleModel sample) async {
    try {
      final colorIndex = selectedColorIndex.value;
      final configIndex = selectedConfigIndex.value;

      // Tính chỉ số của giá tiền dựa trên chỉ số màu sắc và cấu hình
      final index = colorIndex * sample.cauHinh.length + configIndex;

      // Cập nhật giá tiền tại chỉ số tính toán được
      final priceList = List<int>.from(sample.giaTien); // Sao chép danh sách giá tiền
      priceList[index] = newPrice; // Cập nhật giá tiền tại chỉ số

      await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
        'GiaTien': priceList, // Cập nhật danh sách giá tiền
      });

      // Cập nhật giá tiền trong ứng dụng
      sample.giaTien = priceList; // Cập nhật danh sách giá tiền

      updatePrice(sample); // Cập nhật giá tiền hiển thị dựa trên giá tiền mới
    } catch (e) {
      print("Lỗi phát sinh: $e");
    }
  }

  void removeColorFromFirestore(ProductSampleModel sample, int index) async {
    sample.mauSac.removeAt(index);
    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'MauSac': sample.mauSac,
    });
    update();
  }

  void removeConfigFromFirestore(ProductSampleModel sample, int index) async {
    sample.cauHinh.removeAt(index);
    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'CauHinh': sample.cauHinh,
    });
    update();
  }

  void removePriceFromFirestore(ProductSampleModel sample, int index) async {
    sample.giaTien.removeAt(index);
    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'GiaTien': sample.giaTien,
    });
    update();
  }

  Future<void> updateProductSample(ProductSampleModel sample) {
    return _firestore.collection('MauSanPham').doc(sample.id).update(sample.toMap());
  }

  Stream<List<ProductSampleModel>> getSampleProduct() {
    return _firestore.collection("MauSanPham").snapshots().map((event) {
      var item = event.docs.map((e) => ProductSampleModel.fromMap(e.data())).toList();
      sampleProduct.value = item;
      return item;
    });
  }

  void updatePriceWhenHaveNot(int newPrice, ProductSampleModel sample) async {
    final colorIndex = selectedColorIndex.value;
    final configIndex = selectedConfigIndex.value;

    // Tính chỉ số của giá tiền dựa trên chỉ số màu sắc và cấu hình
    final index = colorIndex * sample.cauHinh.length + configIndex;

    // Đảm bảo danh sách giá tiền đủ dài
    if (index >= sample.giaTien.length) {
      sample.giaTien.addAll(List<int>.filled(index - sample.giaTien.length + 1, 0));
    }

    // Cập nhật giá tiền tại chỉ số tính toán được
    sample.giaTien[index] = newPrice;

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'GiaTien': sample.giaTien, // Cập nhật danh sách giá tiền
    });

    // Cập nhật giá tiền trong ứng dụng
    update();
    clearControllers();
  }

  void addPrices() {
    variantPrices.add({
      'GiaTien': TextEditingController(),
    });
  }

  void addColors() {
    variantColors.add({
      'MauSac': TextEditingController(),
    });
  }

  void addConfigs() {
    variantConfigs.add({
      'CauHinh': TextEditingController(),
    });
  }

  void removeVariantColors(int index) {
    variantColors.removeAt(index);
  }

  void removeVariantConfigs(int index) {
    variantConfigs.removeAt(index);
  }

  void removeVariantPridces(int index) {
    variantPrices.removeAt(index);
  }

  Future<void> saveProductSample(String maSanPham) async {
    try {
      List<String> mauSac = variantColors.map((variant) => variant['MauSac']!.text).toList();
      List<String> cauHinh = variantConfigs.map((variant) => variant['CauHinh']!.text).toList();
      List<int> giaTien = variantPrices.map((variant) => int.parse(variant.values.first.text)).toList();
      String id = _firestore.collection('MauSanPham').doc().id;
      ProductSampleModel sample = ProductSampleModel(
        id: id,
        MaSanPham: maSanPham,
        soLuong: 1,
        mauSac: mauSac,
        cauHinh: cauHinh,
        giaTien: giaTien,
      );

      await _firestore.collection('MauSanPham').doc(id).set(sample.toJson());
      clearControllers();
    } catch (e) {
      print("Phát sinh lỗi: $e");
    }
  }

  void addColor(ProductSampleModel sample) async {
    // Lấy danh sách màu sắc hiện tại từ Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).get();
    List<String> existingColors = List<String>.from(snapshot['MauSac']);

    // Thêm màu sắc mới vào danh sách hiện tại
    List<String> newColors = variantColors.map((variant) => variant['MauSac']!.text).toList();
    existingColors.addAll(newColors);

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'MauSac': existingColors, // Cập nhật danh sách màu sắc
    });

    // Cập nhật màu sắc trong ứng dụng
    sample.mauSac = existingColors;
    update();
    clearControllers();
  }

  void addConfig(ProductSampleModel sample) async {
    // Lấy danh sách màu sắc hiện tại từ Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).get();
    List<String> existingConfigs = List<String>.from(snapshot['CauHinh']);

    // Thêm màu sắc mới vào danh sách hiện tại
    List<String> newConfigs = variantConfigs.map((variant) => variant['CauHinh']!.text).toList();
    existingConfigs.addAll(newConfigs);

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'CauHinh': existingConfigs, // Cập nhật danh sách màu sắc
    });

    // Cập nhật màu sắc trong ứng dụng
    sample.cauHinh = existingConfigs;
    update();
    clearControllers();
  }

  void addPrice(ProductSampleModel sample) async {
    // Lấy danh sách màu sắc hiện tại từ Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).get();
    List<int> existingPrices = List<int>.from(snapshot['GiaTien']);

    // Thêm màu sắc mới vào danh sách hiện tại
    List<int> newPrices = variantPrices.map(((variant) => variant['GiaTien']!.text)).cast<int>().toList();
    existingPrices.addAll(newPrices);

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'GiaTien': existingPrices, // Cập nhật danh sách màu sắc
    });

    // Cập nhật màu sắc trong ứng dụng
    sample.giaTien = existingPrices;
    update();
    clearControllers();
  }

  void clearControllers() {
    for (var variant in variantColors) {
      variant['MauSac']?.clear();
    }
    for (var variant in variantConfigs) {
      variant['CauHinh']?.clear();
    }
    for (var variant in variantPrices) {
      variant['GiaTien']?.clear();
    }
    newPriceController.clear();
    variantColors.clear();
    variantConfigs.clear();
    variantPrices.clear();
  }

  void checkPrice(ProductSampleModel sample) {
    final index = selectedColorIndex.value * sample.cauHinh.length + selectedConfigIndex.value;
    if (index < sample.giaTien.length) {
      currentPrice.value = sample.giaTien[index];
    } else {
      currentPrice.value = 0;
    }
  }
}
