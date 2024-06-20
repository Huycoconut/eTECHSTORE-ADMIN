import 'package:etech_store_admin/services/auth_services.dart';
import 'package:etech_store_admin/utlis/connection/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final NetworkManager network = Get.put(NetworkManager());
  final AuthServices authServices = Get.put(AuthServices());

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  //Variables
  final hidePassword = true.obs;
  final hideConformPassword = true.obs;
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final conformPassword = TextEditingController();
  final newPassword = TextEditingController();
  Rx<bool> checkEmail = false.obs;

//change Password
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  void clearPassword() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  //SignUp
}
