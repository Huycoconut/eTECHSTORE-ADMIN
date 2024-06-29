import 'package:cloud_firestore/cloud_firestore.dart';

class ModelProductModel {
  List<dynamic> CauHinh;
  Map GiaTien;
  String MaSanPham;
  List<dynamic> MauSac;
  int SoLuong;
  String id;

  ModelProductModel(
      {required this.id,
      required this.CauHinh,
      required this.GiaTien,
      required this.MaSanPham,
      required this.MauSac,
      required this.SoLuong});

  static empty() => ModelProductModel(
      id: '', CauHinh: [], GiaTien: {}, MaSanPham: '', MauSac: [], SoLuong: 0);

  factory ModelProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (documentSnapshot.data() != null) {
      final data = documentSnapshot.data()!;
      return ModelProductModel(
          id: data['id'] ?? '',
          CauHinh: data['CauHinh'] ?? [],
          GiaTien: data['GiaTien'] ?? {},
          MaSanPham: data['MaSanPham'] ?? '',
          MauSac: data['MauSac'] ?? [],
          SoLuong: data['SoLuong'] ?? 0);
    } else {
      return ModelProductModel.empty();
    }
  }
}
