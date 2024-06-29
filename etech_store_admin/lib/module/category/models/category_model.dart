import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String HinhAnh;
  String MoTa;
  String TenDanhMuc;
  int TrangThai;
  int id;

  CategoryModel(
      {required this.HinhAnh,
      required this.MoTa,
      required this.TenDanhMuc,
      required this.TrangThai,
      required this.id});

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return CategoryModel(
          HinhAnh: data['HinhAnh'] ?? '',
          MoTa: data['MoTa'] ?? '',
          TenDanhMuc: data['TenDanhMuc'] ?? '',
          TrangThai: data['TrangThai'] ?? 0,
          id: data['id'] ?? -1);
    } else {
      return CategoryModel(
          HinhAnh: '', MoTa: '', TenDanhMuc: '', TrangThai: 0, id: -1);
    }
  }
}
