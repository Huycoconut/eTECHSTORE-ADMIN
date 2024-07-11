import 'package:cloud_firestore/cloud_firestore.dart';

class DetailOrders {
  Map<String, dynamic> maMauSanPham;
  String maDonHang;
  int soLuong;
  int khuyenMai;
  int trangThai;

  DetailOrders({
    required this.maMauSanPham,
    required this.maDonHang,
    required this.soLuong,
    required this.khuyenMai,
    required this.trangThai,
  });

  factory DetailOrders.fromJson(Map<String, dynamic> json) {
    return DetailOrders(
      maMauSanPham: json['MaMauSanPham'],
      maDonHang: json['MaDonHang'] as String,
      soLuong: json['SoLuong'] as int,
      khuyenMai: json['KhuyenMai'] as int,
      trangThai: json['TrangThai'] as int,
    );
  }

  factory DetailOrders.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return DetailOrders(
          maMauSanPham: data['MaMauSanPham'] ?? '',
          maDonHang: data['MaDonHang'] ?? '',
          soLuong: data['SoLuong'] ?? 0,
          khuyenMai: 0,
          trangThai: data['TrangThai'] ?? 0);
    } else {
      return DetailOrders(
          maMauSanPham: {},
          maDonHang: '',
          soLuong: 0,
          khuyenMai: 0,
          trangThai: 0);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'MaMauSanPham': maMauSanPham,
      'MaDonHang': maDonHang,
      'SoLuong': soLuong,
      'KhuyenMai': khuyenMai,
      'TrangThai': trangThai,
    };
  }
}
