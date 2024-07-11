import 'dart:convert';

import 'package:etech_store_admin/module/home/controller/user_management_cotroller.dart';
import 'package:etech_store_admin/module/home/view/widget/button_change_cancell_widget.dart';
import 'package:etech_store_admin/module/home/view/widget/chose_image_widget.dart';
import 'package:etech_store_admin/module/home/view/widget/text_field_widget.dart';
import 'package:etech_store_admin/module/profile/controller/profile_controller.dart';
import 'package:etech_store_admin/services/provinces_api/model/provinces_api_servics_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:etech_store_admin/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vn_provinces/province.dart';
import 'package:vn_provinces/vn_provinces.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    return ScreenUtilInit(
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          title: const Text('Thêm Người Dùng'),
          backgroundColor: TColros.purple_line,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Xin Chào, Admin', style: TextStyle(color: Colors.white)),
                  Icon(Icons.account_circle, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChoseImageWidget(),
                const SizedBox(height: 10),
                const Text('Họ và Tên', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                TextFiewWidget(
                    color: Colors.grey,
                    hinhText: "Nhập họ tên",
                    icon: const Icon(Icons.person_outline_rounded, color: Colors.grey),
                    controller: controller.fullNameController),
                const SizedBox(height: 10),
                const Text('Số Điện Thoại', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: controller.phoneNumberController,
                  decoration: InputDecoration(
                    isDense: true, // Added this
                    contentPadding: const EdgeInsets.all(8),
                    prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    hintText: "Nhập số điện thoại",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                TextFiewWidget(
                    color: TColros.grey,
                    hinhText: "Nhập Email",
                    icon: const Icon(Icons.mail_outline, color: TColros.grey),
                    controller: controller.emailController),
                const SizedBox(height: 10),
                const Text('Mật khẩu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Obx(
                  () => TextFormField(
                    controller: controller.passWordController,
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.hidePassword.value = !controller.hidePassword.value;
                        },
                        icon: Icon(controller.hidePassword.value ? Icons.visibility : Icons.visibility_off),
                      ),
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.all(8),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      hintText: "Nhập mật khẩu",
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Nhập lại mật khẩu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPassWordController,
                    obscureText: controller.hideConfirmPassword.value,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.hideConfirmPassword.value = !controller.hideConfirmPassword.value;
                        },
                        icon: Icon(controller.hideConfirmPassword.value ? Icons.visibility : Icons.visibility_off),
                      ),
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.all(8),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      hintText: "Nhập lại mật khẩu",
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Chọn tỉnh/thành phố', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: .5),
                          ),
                          child: DropdownButton<Province>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(color: Colors.black),
                            hint: const Text('Chọn một tỉnh/thành phố', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                            value: controller.selectedProvince.value,
                            onChanged: controller.selectProvince,
                            items: controller.provinces.map((Province province) {
                              return DropdownMenuItem<Province>(
                                value: province,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(province.name),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                      Obx(() {
                        return controller.selectedProvince.value != null
                            ? Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: .5),
                                ),
                                child: DropdownButton<District>(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(color: Colors.black),
                                  hint: const Text('Chọn một quận/huyện', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                  value: controller.selectedDistrict.value,
                                  onChanged: controller.selectDistrict,
                                  items: controller.selectedProvince.value!.districts.map((District district) {
                                    return DropdownMenuItem<District>(
                                      value: district,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(district.name),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Container();
                      }),
                      const SizedBox(height: 5),
                      Obx(() {
                        return controller.selectedDistrict.value != null
                            ? Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: .5),
                                ),
                                child: DropdownButton<Ward>(
                                  isExpanded: true,
                                  alignment: Alignment.centerLeft,
                                  style: const TextStyle(color: Colors.black),
                                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                  underline: const SizedBox(),
                                  hint: const Text('Chọn một phường/xã', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  value: controller.selectedWard.value,
                                  onChanged: controller.selectWard,
                                  items: controller.selectedDistrict.value!.wards.map((Ward ward) {
                                    return DropdownMenuItem<Ward>(
                                      value: ward,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(ward.name),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Container();
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Địa Chỉ Cụ Thể', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                TextFiewWidget(
                    color: TColros.grey,
                    hinhText: "Nhập địa chỉ cụ thể",
                    icon: const Icon(Icons.location_on_outlined, color: TColros.grey),
                    controller: controller.dressController),
                const SizedBox(height: 10),
                const Text('Ủy Quyền', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Obx(
                  () => Container(
                    width: MediaQuery.of(context).size.width / 1,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(5), border: Border.all(width: .5)),
                    child: DropdownButton<String>(
                      value: controller.selectedAuthorization.value,
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        controller.selectedAuthorization.value = newValue!;
                      },
                      items: controller.authorization.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(children: [
                            Text(value),
                            SizedBox(width: MediaQuery.of(context).size.width / 1.397),
                          ]),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonChangeWidget(
                      colorBackgound: TColros.purple_line,
                      colorText: Colors.white,
                      text: "Luư thay đổi",
                      width: 1.5,
                      onTap: () {
                        if (controller.passWordController.text == controller.confirmPassWordController.text) {
                          controller.createUser();
                        } else {
                          TLoaders.showErrorPopup(title: "Thông báo", description: "Lưu thất bại");
                        }
                      },
                    ),
                    ButtonChangeWidget(
                      colorBackgound: TColros.grey_cancelld,
                      colorText: Colors.white,
                      text: "Hủy",
                      width: 8,
                      onTap: () => controller.resetValues(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
