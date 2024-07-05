import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/product/model/product_sample_model.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/categories_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxList<String> uploadedImages = <String>[].obs;
  RxString thumbnailName = ''.obs;
  RxList<Uint8List> uploadedImageBytes = <Uint8List>[].obs;
  Rxn<Uint8List?> thumbnailBytes = Rxn<Uint8List>();
  RxList<String> uploadedImageNames = <String>[].obs;
  Timestamp date = Timestamp.now();
  RxBool isPopular = false.obs;
  RxInt selectedCategory = 7.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<CategoryModel> categoriesProduct = <CategoryModel>[].obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController mauSacController = TextEditingController();
  ProductSampleController sampleController = Get.put(ProductSampleController());
  Map<int, String> categoryMap = {};
  var itemsPerPage = 8.obs;
  var lstProduct = <ProductModel>[].obs;
  var currentPage = 1.obs;
  late PageController pageController;
  List<ProductModel> allProducts = []; // Danh sách sản phẩm ban đầu

  var searchPrice = ''.obs;
  var searchProductName = ''.obs;
  var searchCategory = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    getProduct();
    getProduct().listen((products) {
      lstProduct.value = products.where((element) => element.trangThai == true).toList();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changePage(int newPage) {
    currentPage.value = newPage;
  }

  void setDefault() {
    uploadedImages.clear();
    thumbnailName.value = '';
    uploadedImageBytes.clear();
    thumbnailBytes.value = null;
    uploadedImageNames.clear();
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    mauSacController.clear();
  }

  void updatePage(int page) {
    currentPage.value = page;
  }

  void initializeProduct(ProductModel product) {
    priceController = TextEditingController(text: "${product.giaTien}");
    nameController = TextEditingController(text: product.ten);
    descriptionController = TextEditingController(text: product.moTa);
  }

  Stream<List<ProductModel>> getProduct() {
    return FirebaseFirestore.instance.collection('SanPham').where('TrangThai', isEqualTo: true).snapshots().map((query) {
      List<ProductModel> products = query.docs.map((doc) => ProductModel.fromFirestore(doc.data())).toList();
      allProducts = products; // Lưu danh sách sản phẩm ban đầu
      return products;
    });
  }

  Future<void> removeListImage(ProductModel product, int e) async {
    int indexToRemove = product.hinhAnh.indexOf(e);
    if (indexToRemove != -1) {
      product.hinhAnh.removeAt(indexToRemove);
    }
    await FirebaseFirestore.instance.collection('SanPham').doc(product.id).update({'DSHinhAnh': product.hinhAnh});
  }

  Stream<List<CategoryModel>> typeCategori() {
    return _firestore.collection('DanhMucSanPham').snapshots().map((snapshot) {
      categoryMap.clear();
      return snapshot.docs.map((document) {
        var category = CategoryModel.fromSnapshot(document);
        categoryMap[category.id] = category.TenDanhMuc;
        return category;
      }).toList();
    });
  }

  Stream<List<CategoryModel>> getCategories() {
    return _firestore.collection('DanhMucSanPham').snapshots().map((snapshot) {
      categoryMap.clear();
      return snapshot.docs.map((document) {
        var category = CategoryModel.fromSnapshot(document);
        categoryMap[category.id] = category.TenDanhMuc;
        return category;
      }).toList();
    });
  }

  Stream<List<ProductSampleModel>> getSampleProduct() {
    return _firestore.collection("MauSanPham").snapshots().map((event) {
      return event.docs.map((e) => ProductSampleModel.fromMap(e.data())).toList();
    });
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('DanhMucSanPham').get();
      categories.add(CategoryModel(
        id: 7,
        TenDanhMuc: 'Chọn danh mục',
        MoTa: 'Tất cả sản phẩm của cửa hàng',
        HinhAnh: 'keyboard',
        TrangThai: 1,
      ));
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        categories.add(CategoryModel.fromJson(data));
      }
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lỗi Xảy Ra Trong Quá Trình Lấy Dữ Liệu", onDismissed: () => const Text(""));
    }
  }

  Future<void> fetchCategoriesProduct(CategoryModel cate) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('DanhMucSanPham').get();
      categoriesProduct
          .add(CategoryModel(id: cate.id, TenDanhMuc: cate.TenDanhMuc, MoTa: cate.MoTa, HinhAnh: cate.HinhAnh, TrangThai: cate.TrangThai));
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        categoriesProduct.add(CategoryModel.fromJson(data));
      }
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lỗi Xảy Ra Trong Quá Trình Lấy Dữ Liệu", onDismissed: () => const Text(""));
    }
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("SanPham").where('id', isEqualTo: id).get();
      for (int i = 0; i < uploadedImageBytes.length; i++) {
        final storageRef = _storage.ref().child('products/${uploadedImageNames[i]}');
        UploadTask uploadTask = storageRef.putData(uploadedImageBytes[i]);
        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          uploadedImages.add(downloadUrl);
        });
      }

      if (thumbnailBytes.value != null && thumbnailBytes.value!.isNotEmpty) {
        final storageRef = _storage.ref().child('thumbnails/${thumbnailName.value}');
        UploadTask uploadTask = storageRef.putData(thumbnailBytes.value!);
        await uploadTask.whenComplete(() async {
          thumbnailName.value = await storageRef.getDownloadURL();
        });
      } else {
        thumbnailName.value.isEmpty;
      }

      for (var doc in querySnapshot.docs) {
        String documentId = doc.id;
        Map<String, dynamic> updateData = {
          'DSHinhAnh': uploadedImages.isNotEmpty ? uploadedImages.toList() : product.hinhAnh,
          'GiaTien': int.parse(priceController.text),
          'KhuyenMai': 10,
          'MaDanhMuc': selectedCategory.value,
          'NgayNhap': Timestamp.now(),
          'Ten': nameController.text,
          'TrangThai': true,
          'thumbnail': thumbnailName.value.isNotEmpty ? thumbnailName.value : product.thumbnail,
          'MoTa': descriptionController.text,
        };
        await _firestore.collection("SanPham").doc(documentId).update(updateData);
      }
      TLoaders.showSuccessPopup(title: "Thông báo", description: "Lưu Thành Công", onDismissed: () => const Text(""));
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông báo", description: "Lưu Thất Bại", onDismissed: () => const Text(""));
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      for (int i = 0; i < uploadedImageBytes.length; i++) {
        final storageRef = _storage.ref().child('products/${uploadedImageNames[i]}');
        UploadTask uploadTask = storageRef.putData(uploadedImageBytes[i]);
        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          uploadedImages.add(downloadUrl);
        });
      }

      final storageRef = _storage.ref().child('thumbnails/${thumbnailName.value}');
      UploadTask uploadTask = storageRef.putData(thumbnailBytes.value!);

      await uploadTask.whenComplete(() async {
        thumbnailName.value = await storageRef.getDownloadURL();
      });

      product.hinhAnh = uploadedImages;
      product.thumbnail = thumbnailName.value;
      if (uploadedImages.isEmpty ||
          thumbnailName.isEmpty ||
          nameController.text.isEmpty ||
          priceController.text.isEmpty ||
          descriptionController.text.isEmpty ||
          searchCategory.value == 7) {
        TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại", onDismissed: () => const Text(""));
      } else {
        DocumentReference docRef = _firestore.collection('SanPham').doc();
        product.id = docRef.id;
        sampleController.saveProductSample(product.id);
        await docRef.set(product.toJson());
        setDefault();
        sampleController.clearControllers();
      }
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại", onDismissed: () => const Text(""));
    }
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        if (file.bytes != null) {
          Uint8List fileBytes = file.bytes!;
          uploadedImageBytes.add(fileBytes);
          uploadedImageNames.add('${DateTime.now().millisecondsSinceEpoch}_${file.name}');
        }
      }
    }
  }

  Future<void> pickThumbnail() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      thumbnailBytes.value = fileBytes;
      thumbnailName.value = '${DateTime.now().millisecondsSinceEpoch}_${result.files.first.name}';
    }
  }

  Future<void> setThumbnail(String url) async {
    thumbnailName.value = url;
  }

  String generateId() {
    return _firestore.collection('SanPham').doc().id;
  }
}