import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/preview/models/preview_model.dart';
import 'package:etech_store_admin/module/preview/models/product_model.dart';
import 'package:etech_store_admin/module/preview/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PreviewController extends GetxController {
  static PreviewController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final adminID = FirebaseAuth.instance.currentUser!.uid;
  RxList<PreviewModel> listpreviews = <PreviewModel>[].obs;
  RxList<UserModel> listUser = <UserModel>[].obs;
  RxList<ProductModel> listProduct = <ProductModel>[].obs;
  RxBool sortAscending = true.obs;
  RxInt sortColumnIndex = 0.obs;
  @override
  void onInit() {
    fetchPreviews();
    super.onInit();
  }

  Future<void> fetchPreviews() async {
    db
        .collection('DanhGia')
        .orderBy('TrangThai')
        .snapshots()
        .listen((previews) {
      listpreviews.clear();
      previews.docs.forEach((preview) {
        listpreviews.add(PreviewModel.fromSnapshot(preview));
      });
    });
    db.collection('Users').snapshots().listen((users) {
      listUser.clear();
      users.docs.forEach((user) {
        listUser.add(UserModel.fromSnapshot(user));
      });
    });
    db.collection('SanPham').snapshots().listen((users) {
      listProduct.clear();
      users.docs.forEach((user) {
        listProduct.add(ProductModel.fromSnapshot(user));
      });
    });
  }

  String getUserName(String userID) {
    String userName = '';
    for (var user in listUser) {
      if (user.uid == userID) {
        userName = user.HoTen;
      }
    }
    return userName;
  }

  String getProductName(String productID) {
    String productName = '';
    for (var product in listProduct) {
      if (product.id == productID) {
        if (product.Ten.length > 40) {
          productName = '${product.Ten.substring(0, 40)}...';
        } else {
          productName = product.Ten;
        }
      }
    }
    return productName;
  }

  Future<void> approvePreview(String previewID) async {
    await db
        .collection('DanhGia')
        .where('id', isEqualTo: previewID)
        .get()
        .then((snapshot) => snapshot.docs.forEach((preview) {
              preview.reference.update({'TrangThai': true});
            }));
  }

  Future<void> removePreview(String previewID) async {
    await db
        .collection('DanhGia')
        .where('id', isEqualTo: previewID)
        .get()
        .then((snapshot) => snapshot.docs.forEach((preview) {
              preview.reference.delete();
            }));
  }

  void onSortColumn(int columnIndex, bool ascending) {
    sortColumnIndex = columnIndex.obs;
    sortAscending = ascending.obs;
    listpreviews.sort((a, b) => ascending
        ? a.TrangThai.toString().compareTo(b.TrangThai.toString())
        : b.TrangThai.toString().compareTo(a.TrangThai.toString()));
  }

  void onSortStarColumn(int columnIndex, bool ascending) {
    sortColumnIndex = columnIndex.obs;
    sortAscending = ascending.obs;
    listpreviews.sort((a, b) =>
        ascending ? a.SoSao.compareTo(b.SoSao) : b.SoSao.compareTo(a.SoSao));
  }
}
