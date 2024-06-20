import 'package:etech_store_admin/module/auth/controller/forget_password_controller.dart';
import 'package:etech_store_admin/module/auth/views/sign_in_screen.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Lottie.asset(
                ImageKey.successAnimation,
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 8,
                repeat: true,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(email,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),
              const Text("Đã gửi email đặt lại mật khẩu",
                  style: TColros.black_21_bold),
              const SizedBox(height: 15),
              Text("Hãy kiểm tra email và đặt lại mật khẩu ",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(() => const SignInScreenMobile());
                    },
                    child: const Text("Xong")),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
