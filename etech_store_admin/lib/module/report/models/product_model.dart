import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String Ten;
  String MoTa;
  String thumbnail;
  List<dynamic> HinhAnh;
  Timestamp NgayNhap;
  int GiaTien;
  int KhuyenMai;
  int MaDanhMuc;
  bool isPopular;
  bool TrangThai;
  int quantity;

  ProductModel(
      {required this.id,
      required this.Ten,
      required this.MoTa,
      required this.thumbnail,
      required this.HinhAnh,
      required this.NgayNhap,
      required this.GiaTien,
      required this.KhuyenMai,
      required this.MaDanhMuc,
      required this.isPopular,
      required this.TrangThai,
      required this.quantity});

  //Empty Product
  static ProductModel empty() => ProductModel(
      id: '',
      Ten: '',
      MoTa: '',
      thumbnail: '',
      HinhAnh: [],
      NgayNhap: Timestamp.now(),
      GiaTien: 0,
      KhuyenMai: 0,
      MaDanhMuc: 0,
      isPopular: false,
      TrangThai: false,
      quantity: 0);

  //
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json to Model
      return ProductModel(
          id: document.id,
          Ten: data['Ten'] ?? '',
          MoTa: data['MoTa'] ?? '',
          thumbnail: data['thumbnail'] ?? '',
          HinhAnh: data['DSHinhAnh'] ?? [],
          NgayNhap: data['NgayNhap'] ?? Timestamp.now(),
          GiaTien: data['GiaTien'] ?? '',
          KhuyenMai: data['KhuyenMai'] ?? '',
          MaDanhMuc: data['MaDanhMuc'] ?? 0,
          isPopular: data['isPopular'] ?? false,
          TrangThai: data['TrangThai'] ?? false,
          quantity: 0);
    } else {
      return ProductModel.empty();
    }
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      thumbnail: json['thumbnail'],
      HinhAnh: json['DSHinhAnh'] as List<dynamic>,
      MaDanhMuc: json['MaDanhMuc'],
      // mauSac: json['MauSac'],
      GiaTien: json['GiaTien'],
      id: json['id'],
      KhuyenMai: json['KhuyenMai'],
      MoTa: json['MoTa'],
      Ten: json['Ten'],
      TrangThai: json['TrangThai'],
      NgayNhap: json['NgayNhap'] ?? Timestamp.now(),
      isPopular: json['isPopular'] ?? false,
      quantity: 0);
}
