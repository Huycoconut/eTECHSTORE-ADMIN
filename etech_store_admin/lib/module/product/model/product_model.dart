import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  int KhuyenMai;
  String moTa;
  String ten;
  bool trangThai;
  int giaTien;
  int maDanhMuc;
  List<dynamic> hinhAnh;
  String thumbnail;
  bool isPopular;
  Timestamp NgayNhap;

  ProductModel(
      {required this.thumbnail,
      required this.hinhAnh,
      required this.maDanhMuc,
      required this.id,
      required this.KhuyenMai,
      required this.moTa,
      required this.ten,
      required this.trangThai,
      required this.giaTien,
      required this.NgayNhap,
      required this.isPopular});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        thumbnail: json['thumbnail'],
        hinhAnh: json['DSHinhAnh'] as List<dynamic>,
        maDanhMuc: json['MaDanhMuc'],
        NgayNhap: json['NgayNhap'] ?? Timestamp.now(),
        isPopular: json['isPopular'],
        giaTien: json['GiaTien'],
        id: json['id'],
        KhuyenMai: json['KhuyenMai'],
        moTa: json['MoTa'],
        ten: json['Ten'],
        trangThai: json['TrangThai'],
      );

  Map<String, dynamic> toJson() {
    final json = {
      'thumbnail': thumbnail,
      'DSHinhAnh': hinhAnh,
      'MaDanhMuc': maDanhMuc,
      'NgayNhap': NgayNhap,
      'isPopular': isPopular,
      'GiaTien': giaTien,
      'id': id,
      'KhuyenMai': KhuyenMai,
      'MoTa': moTa,
      'Ten': ten,
      'TrangThai': trangThai,
    };
    return json;
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ProductModel(
      thumbnail: document['thumbnail'],
      hinhAnh: document['DSHinhAnh'],
      maDanhMuc: document['MaDanhMuc'],
      id: document['id'],
      NgayNhap: document['NgayNhap'],
      isPopular: document['isPopular'],
      KhuyenMai: document['KhuyenMai'],
      moTa: document['MoTa'],
      ten: document['Ten'],
      trangThai: document['TrangThai'],
      giaTien: document['GiaTien'],
    );
  }

  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      NgayNhap: data['NgayNhap'],
      isPopular: data['isPopular'],
      id: data['id'] ?? '',
      KhuyenMai: data['KhuyenMai'] ?? 0,
      moTa: data['MoTa'] ?? '',
      ten: data['Ten'] ?? '',
      trangThai: data['TrangThai'] ?? false,
      giaTien: data['GiaTien'] ?? 0,
      maDanhMuc: data['MaDanhMuc'] ?? 0,
      hinhAnh: List<dynamic>.from(data['DSHinhAnh'] ?? []),
      thumbnail: data['thumbnail'] ?? '',
    );
  }
}
