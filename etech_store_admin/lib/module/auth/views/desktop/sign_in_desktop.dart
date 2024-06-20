import 'package:etech_store_admin/module/auth/controller/sign_in_controller.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInScreenDestop extends GetView<SignInController> {
  const SignInScreenDestop({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final controller = Get.put(SignInController());
    return Form(
      key: controller.signInFormKey,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 19, 136, 178),
        body: ScreenUtilInit(
          builder: (context, child) => SingleChildScrollView(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 70),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 550,
                width: 450,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageKey.logoEtechStore,
                      width: 125.w,
                      height: 125.h,
                    ),
                    const Text("e T E C H S T O R E", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 30),
                    const Text("Quản Trị Viên Đăng Nhập",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, fontFamily: AutofillHints.familyName)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Email", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                          SizedBox(height: 5.h),
                          TextFormField(
                            controller: controller.email,
                            decoration: InputDecoration(
                              isDense: true, // Added this
                              contentPadding: const EdgeInsets.all(8),
                              prefixIcon: const Icon(Icons.email_outlined, color: TColros.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: TTexts.nhapEmail,
                              hintStyle: const TextStyle(color: TColros.grey),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          const Text("Mật khẩu",
                              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                          SizedBox(height: 5.h),
                          Obx(
                            () => TextFormField(
                              controller: controller.password,
                              obscureText: controller.hidePassword.value,
                              decoration: InputDecoration(
                                isDense: true, // Added this
                                contentPadding: const EdgeInsets.all(8),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: TColros.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: TColros.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: TColros.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: TTexts.nhapMatKhau,
                                hintStyle: const TextStyle(color: TColros.grey),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.hidePassword.value = !controller.hidePassword.value;
                                  },
                                  icon: Icon(controller.hidePassword.value ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text("*Vui lòng đăng nhập tài khoản đã cung cấp",
                              style: TextStyle(fontSize: 15, color: Colors.grey)),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              controller.signIn();
                            },
                            child: Container(
                              width: 400,
                              height: 40,
                              decoration: BoxDecoration(
                                color: TColros.purple_line,
                                border: Border.all(width: .5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  TTexts.dangNhap,
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
