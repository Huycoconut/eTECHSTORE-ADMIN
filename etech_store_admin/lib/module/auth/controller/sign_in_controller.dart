import 'package:etech_store_admin/services/auth_services.dart';
import 'package:etech_store_admin/utlis/connection/network_manager.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:etech_store_admin/utlis/helpers/dialog/alert_dialog.dart';
import 'package:etech_store_admin/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();
  final AuthServices authServices = Get.put(AuthServices());
  final NetworkManager network = Get.put(NetworkManager());

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  //Variables
  final hidePassword = true.obs;
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final conformPassword = TextEditingController();
  final phoneNumber = TextEditingController();
  FocusNode textFocusNodeEmail = FocusNode();
  final RxBool isEditingEmail = false.obs;
  FocusNode textFocusNodePassword = FocusNode();

  Rx<String> verify = "".obs;
  Rx<String> code = "".obs;

  //SignIn
  void signIn() async {
    FullScreenLoader.openLoadingDialog('', ImageKey.loadingAnimation);
    final isconnected = network.isConnectedToInternet.value;
    try {
      if (!isconnected) {
        TLoaders.errorSnackBar(
            title: TTexts.thongBao, message: "Không có kết nối internet");
        return;
      } else {
        await authServices.signInWithEmailAndPassword(
            email.text.trim(), password.text.trim());
      }
    } catch (e) {
      if (email.text.isEmpty || password.text.isEmpty) {
        TLoaders.errorSnackBar(
            title: TTexts.thongBao, message: TTexts.chuaNhapDuThongTin);
      } else {
        TLoaders.errorSnackBar(
            title: TTexts.thongBao, message: TTexts.saiEmailHoacMatKhau);
      }
    }
  }

  //check null
  void checkIsEmpty(BuildContext context, TextEditingController emailController,
      TextEditingController passwordController) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ETAlertDialog.showSuccessDialog(
          context, TTexts.chuaEmailHoacMatKhau, TTexts.thongBao);
    }
  }
}
