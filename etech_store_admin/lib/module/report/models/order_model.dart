import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String MaKhachHang;
  int TongTien;
  int TongDuocGiam;
  Timestamp NgayTaoDon;
  bool isPaid;
  bool isBeingShipped;
  bool isShipped;
  bool isCompleted;
  bool isCancelled;

  OrderModel(
      {required this.id,
      required this.MaKhachHang,
      required this.TongTien,
      required this.TongDuocGiam,
      required this.NgayTaoDon,
      required this.isPaid,
      required this.isBeingShipped,
      required this.isShipped,
      required this.isCompleted,
      required this.isCancelled});

  static empty() => OrderModel(
      id: '',
      MaKhachHang: '',
      TongTien: 0,
      TongDuocGiam: 0,
      NgayTaoDon: Timestamp.now(),
      isPaid: false,
      isBeingShipped: false,
      isShipped: false,
      isCompleted: false,
      isCancelled: false);

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
          id: data['id'] ?? '',
          MaKhachHang: data['MaKhachHang'] ?? '',
          TongTien: data['TongTien'] ?? 0,
          TongDuocGiam: data['TongDuocGiam'] ?? 0,
          NgayTaoDon: data['NgayTaoDon'] ?? Timestamp.now(),
          isPaid: data['isPaid'] ?? false,
          isBeingShipped: data['isBeingShipped'] ?? false,
          isShipped: data['isShipped'] ?? false,
          isCompleted: data['isCompleted'] ?? false,
          isCancelled: data['isCancelled'] ?? false);
    } else {
      return OrderModel.empty();
    }
  }
}
