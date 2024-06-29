import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  List<dynamic> DSSanPham;
  String MaKhachHang;

  WishlistModel({required this.DSSanPham, required this.MaKhachHang});

  factory WishlistModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return WishlistModel(
          DSSanPham: data['DSSanPham'] ?? [],
          MaKhachHang: data['MaKhachHang'] ?? '');
    } else {
      return WishlistModel(DSSanPham: [], MaKhachHang: '');
    }
  }
}
