import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String DiaChi;
  String HinhDaiDien;
  String HoTen;
  int SoDienThoai;
  bool Quyen;
  String email;
  String password;
  int TrangThai;

  UserModel(
      {required this.uid,
      required this.DiaChi,
      required this.HinhDaiDien,
      required this.HoTen,
      required this.SoDienThoai,
      required this.Quyen,
      required this.email,
      required this.password,
      required this.TrangThai});

  static empty() => UserModel(
      uid: '',
      DiaChi: '',
      HinhDaiDien: '',
      HoTen: '',
      SoDienThoai: 0,
      Quyen: true,
      email: '',
      password: '',
      TrangThai: 0);

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return UserModel(
          uid: data['uid'] ?? '',
          DiaChi: data['DiaChi'] ?? '',
          HinhDaiDien: data['HinhDaiDien'] ?? '',
          HoTen: data['HoTen'] ?? '',
          SoDienThoai: data['SoDienThoai'] ?? 0,
          Quyen: data['Quyen'] ?? true,
          email: data['email'] ?? '',
          password: data['password'] ?? '',
          TrangThai: data['TrangThai'] ?? 0);
    } else {
      return UserModel.empty();
    }
  }
}
