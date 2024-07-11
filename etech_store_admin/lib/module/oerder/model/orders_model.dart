import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String id;
  final Timestamp ngayTaoDon;
  final String maKhachHang;
  final int tongTien;
  bool isPaid;
  bool isBeingShipped;
  bool isShipped;
  bool isCompleted;

  OrdersModel({
    required this.id,
    required this.ngayTaoDon,
    required this.maKhachHang,
    required this.tongTien,
    required this.isPaid,
    required this.isBeingShipped,
    required this.isShipped,
    required this.isCompleted,
  });

  factory OrdersModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrdersModel(
      id: doc.id,
      ngayTaoDon: data['NgayTaoDon'],
      maKhachHang: data['MaKhachHang'],
      tongTien: data['TongTien'],
      isPaid: data['isPaid'] ?? false,
      isBeingShipped: data['isBeingShipped'] ?? false,
      isShipped: data['isShipped'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  void updateState(String selectedValue) {
    isBeingShipped = selectedValue == 'Being Shipped';
    isShipped = selectedValue == 'Shipped';
    isCompleted = selectedValue == 'Completed';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'NgayTaoDon': ngayTaoDon,
      'MaKhachHang': maKhachHang,
      'TongTien': tongTien,
      'isPaid': isPaid,
      'isBeingShipped': isBeingShipped,
      'isShipped': isShipped,
      'isCompleted': isCompleted,
    };
  }
}
