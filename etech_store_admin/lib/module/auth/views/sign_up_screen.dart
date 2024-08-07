import 'package:etech_store_admin/module/auth/controller/sign_up_controller.dart';
import 'package:etech_store_admin/module/auth/views/sign_in_screen.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:etech_store_admin/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Form(
      key: controller.signUpFormKey,
      child: ScreenUtilInit(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TTexts.taoTaiKhoan,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    TTexts.batDauTaoTaiKhoan,
                    style: const TextStyle(color: TColros.grey, fontSize: 15),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TTexts.tenTaiKhoan,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        //Full name
                        TextFormField(
                          controller: controller.fullName,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_outline_sharp,
                              color: TColros.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: TColros.grey),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: TColros.grey),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            hintText: TTexts.nhapTenTaiKhoan,
                            hintStyle: const TextStyle(color: TColros.grey),
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Text(
                          TTexts.nhapEmail,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        //email
                        TextFormField(
                          validator: (value) {
                            TValidator.validateEmptyText(value, 'email');
                            return null;
                          },
                          expands: false,
                          controller: controller.email,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: TColros.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              hintText: TTexts.nhapEmail,
                              hintStyle: const TextStyle(color: TColros.grey)),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          TTexts.matKhau,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Obx(
                          () => TextFormField(
                            controller: controller.password,
                            obscureText: controller.hidePassword.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: TColros.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: TTexts.nhapMatKhau,
                              hintStyle: const TextStyle(
                                color: TColros.grey,
                              ),
                              fillColor: Colors.grey,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.hidePassword.value =
                                      !controller.hidePassword.value;
                                },
                                icon: Icon(controller.hidePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          TTexts.nhapLaiMatKhau,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Obx(
                          () => TextFormField(
                            controller: controller.conformPassword,
                            obscureText: controller.hideConformPassword.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: TColros.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: TColros.grey),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              hintText: TTexts.nhapLaiMatKhau,
                              hintStyle: const TextStyle(
                                color: TColros.grey,
                              ),
                              fillColor: Colors.grey,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.hideConformPassword.value =
                                      !controller.hideConformPassword.value;
                                },
                                icon: Icon(controller.hideConformPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 130.w, vertical: 17.h),
                          backgroundColor: TColros.purple_line),
                      onPressed: () {},
                      child: Text(
                        TTexts.singUp,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 140.w,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          TTexts.hoac,
                          style: TextStyle(
                              color: TColros.grey,
                              fontSize: ScreenUtil().setSp(15)),
                        ),
                      ),
                      Container(
                        width: 140.w,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                            border: Border.all(width: .5),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 50.w),
                              width: 20.w,
                              height: 20.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(ImageKey.iconGoogle),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              TTexts.dangNhapBangGoogle,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Row(
                      children: [
                        SizedBox(width: 35.w),
                        Text(
                          TTexts.banDaCoTaiKhoan,
                          style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreenMobile()));
                            },
                            child: Text(
                              TTexts.dangNhap,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
