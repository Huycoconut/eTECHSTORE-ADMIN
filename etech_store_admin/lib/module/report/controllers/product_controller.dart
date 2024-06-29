import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/report/models/model_product_model.dart';
import 'package:etech_store_admin/module/report/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  RxList<ProductModel> listProduct = <ProductModel>[].obs;
  RxList<ModelProductModel> listModelProduct = <ModelProductModel>[].obs;
  RxList<ModelProductModel> listModelByProduct = <ModelProductModel>[].obs;

  @override
  void onInit() {
    fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
    db.collection('SanPham').snapshots().listen((products) {
      listProduct.clear();
      products.docs.forEach((product) {
        listProduct.add(ProductModel.fromSnapshot(product));
      });
    });
    db.collection('MauSanPham').snapshots().listen((models) {
      listModelProduct.clear();
      models.docs.forEach((model) {
        listModelProduct.add(ModelProductModel.fromSnapshot(model));
      });
    });
  }

  void getModelProduct(String productID) {
    listModelByProduct.clear();
    for (var model in listModelProduct) {
      if (model.MaSanPham == productID) {
        listModelByProduct.add(model);
      }
    }
  }

  int getQuantityOfProduct(String productID) {
    var quantity = 0;
    getModelProduct(productID);
    for (var model in listModelByProduct) {
      quantity += model.SoLuong;
    }
    return quantity;
  }
}
