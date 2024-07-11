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

  var originalGiaTienMap = <String, int>{}.obs;  

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
    updatePrice(sample);  
  }

  void setSelectedConfigIndex(int index, ProductSampleModel sample) {
    selectedConfigIndex.value = index;
    updatePrice(sample); 
  }

  void updatePrice(ProductSampleModel sample) {
    final colorIndex = selectedColorIndex.value;
    final configIndex = selectedConfigIndex.value;

     final index = colorIndex * sample.cauHinh.length + configIndex;
 
    if (index >= 0 && index < sample.giaTien.length) {
      displayedPrice.value = sample.giaTien[index].toString();
    } else {
      displayedPrice.value = 'Không có giá'; 
    }
  }

  Future<void> updatePriceInFirestore(int newPrice, ProductSampleModel sample) async {
    try {
      final colorIndex = selectedColorIndex.value;
      final configIndex = selectedConfigIndex.value;

       final index = colorIndex * sample.cauHinh.length + configIndex;

       final priceList = List<int>.from(sample.giaTien); 
      priceList[index] = newPrice;  

      await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
        'GiaTien': priceList,  
      });

       sample.giaTien = priceList;  

      updatePrice(sample); 
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

     final index = colorIndex * sample.cauHinh.length + configIndex;

    
    if (index >= sample.giaTien.length) {
      sample.giaTien.addAll(List<int>.filled(index - sample.giaTien.length + 1, 0));
    }

  
    sample.giaTien[index] = newPrice;

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'GiaTien': sample.giaTien,  
    });

    
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
     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).get();
    List<String> existingColors = List<String>.from(snapshot['MauSac']);

     List<String> newColors = variantColors.map((variant) => variant['MauSac']!.text).toList();
    existingColors.addAll(newColors);

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'MauSac': existingColors, 
    });

     sample.mauSac = existingColors;
    update();
    clearControllers();
  }

  void addConfig(ProductSampleModel sample) async {
     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).get();
    List<String> existingConfigs = List<String>.from(snapshot['CauHinh']);

     List<String> newConfigs = variantConfigs.map((variant) => variant['CauHinh']!.text).toList();
    existingConfigs.addAll(newConfigs);

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'CauHinh': existingConfigs, 
    });

     sample.cauHinh = existingConfigs;
    update();
    clearControllers();
  }

  void addPrice(ProductSampleModel sample) async {
     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).get();
    List<int> existingPrices = List<int>.from(snapshot['GiaTien']);

     List<int> newPrices = variantPrices.map(((variant) => int.parse( variant['GiaTien']!.text))).cast<int>().toList();
    existingPrices.addAll(newPrices);

    await FirebaseFirestore.instance.collection('MauSanPham').doc(sample.id).update({
      'GiaTien': existingPrices,  
    });

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
