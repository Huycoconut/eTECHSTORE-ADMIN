 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/main.dart';
import 'package:etech_store_admin/utlis/connection/network_manager.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthServices extends GetxController {
  static AuthServices instance = Get.find();
  late Rx<User?> _user;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final NetworkManager network = Get.put(NetworkManager());
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      TLoaders.warningSnackBar(title: "Thông báo", message: "Sai tài khoản hoặc mật khẩu");
    }
  }

  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      TLoaders.warningSnackBar(title: "Thông báo", message: "Sai tài khoản hoặc mật khẩu");
    }
  }

  //SignUp
  Future<UserCredential?> createUser(String email, String password, String hoten, int sodienthoai, String diaChi, bool quyen, String hinhAnh) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    firestore.collection('Users').add({
      'HoTen': hoten,
      'email': email,
      'password': password,
      'uid': userCredential.user!.uid,
      'HinhDaiDien': hinhAnh,
      'Quyen': quyen,
      'SoDienThoai': sodienthoai,
      'DiaChi': diaChi,
      'TrangThai': 1
    });
    return userCredential;
  }

  Future<void> signOut() async {
    try {
      TLoaders.showConfirmPopup(
          title: "Xác nhận",
          description: "Bạn có muốn đăng xuất",
          onDismissed: () => Navigator.pop(Get.context!),
          conFirm: () => auth.signOut().then((value) {
                return const AuthWrapper();
              }));
    } catch (e) {
      TLoaders.warningSnackBar(title: "Thông báo", message: "Đã có lỗi xảy ra, hãy thử lại");
    }
  }
}
