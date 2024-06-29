import 'package:cloud_firestore/cloud_firestore.dart';

class PreviewModel {
  String id;
  String DanhGia;
  String MaKhachHang;
  String MaSanPham;
  int SoSao;
  bool TrangThai;

  PreviewModel(
      {required this.id,
      required this.DanhGia,
      required this.MaKhachHang,
      required this.MaSanPham,
      required this.SoSao,
      required this.TrangThai});

  static empty() => PreviewModel(
      id: '',
      DanhGia: '',
      MaKhachHang: '',
      MaSanPham: '',
      SoSao: 0,
      TrangThai: false);

  factory PreviewModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return PreviewModel(
          id: data['id'] ?? '',
          DanhGia: data['DanhGia'] ?? '',
          MaKhachHang: data['MaKhachHang'] ?? '',
          MaSanPham: data['MaSanPham'] ?? '',
          TrangThai: data['TrangThai'] ?? false,
          SoSao: data['SoSao'] ?? 0);
    } else {
      return PreviewModel.empty();
    }
  }
}
