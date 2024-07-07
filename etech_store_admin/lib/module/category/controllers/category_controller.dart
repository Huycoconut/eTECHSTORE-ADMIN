import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/category/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final adminID = FirebaseAuth.instance.currentUser!.uid;
  RxList<CategoryModel> listCat = <CategoryModel>[].obs;
  RxInt sortColumnIndex = 0.obs;
  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    db.collection('DanhMucSanPham').orderBy('id').snapshots().listen((cats) {
      listCat.clear();
      cats.docs.forEach((cat) {
        listCat.add(CategoryModel.fromSnapshot(cat));
      });
    });
  }

  Future<void> updateStatusCat(bool status, int idCat) async {
    await db
        .collection('DanhMucSanPham')
        .where('id', isEqualTo: idCat)
        .get()
        .then((snapshot) => snapshot.docs.forEach((cat) {
              cat.reference.update({'TrangThai': status == true ? 0 : 1});
            }));
  }

  Future<void> updateCat(
      String TenDanhMuc, String MoTa, String HinhAnh, int idCat) async {
    await db
        .collection('DanhMucSanPham')
        .where('id', isEqualTo: idCat)
        .get()
        .then((snapshot) => snapshot.docs.forEach((cat) {
              cat.reference.update(
                  {'TenDanhMuc': TenDanhMuc, 'MoTa': MoTa, 'HinhAnh': HinhAnh});
            }));
  }

  Future<void> addCat(String tenDanhMuc, String moTa, String hinhAnh) async {
    await db.collection('DanhMucSanPham').add({
      'id': listCat.last.id + 1,
      'TenDanhMuc': tenDanhMuc,
      'MoTa': moTa,
      'HinhAnh': hinhAnh,
      'TrangThai': 0
    });
  }

  Future<void> removeCat(int catID) async {
    await db
        .collection('DanhMucSanPham')
        .where('id', isEqualTo: catID)
        .get()
        .then((snapshot) => snapshot.docs.forEach((cat) {
              cat.reference.delete();
            }));
  }

  void onSortColumn(int columnIndex, bool ascending) {
    sortColumnIndex = columnIndex.obs;
    sortAscending = ascending.obs;
    listCat.sort((a, b) => ascending
        ? a.TrangThai.toString().compareTo(b.TrangThai.toString())
        : b.TrangThai.toString().compareTo(a.TrangThai.toString()));
  }
}
