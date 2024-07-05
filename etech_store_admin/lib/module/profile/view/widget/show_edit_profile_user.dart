import 'package:etech_store_admin/module/home/view/widget/button_change_cancell_widget.dart';
import 'package:etech_store_admin/module/home/view/widget/text_field_widget.dart';
import 'package:etech_store_admin/module/profile/controller/profile_controller.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/model/categories_model.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/product/model/product_sample_model.dart';
import 'package:etech_store_admin/module/product/view/widget/add_configs.dart';
import 'package:etech_store_admin/module/product/view/widget/add_atribute_sample.dart';
import 'package:etech_store_admin/module/product/view/widget/manage_sample.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowEditUser {
  static Future<void> showEditUser(BuildContext context, ProfileModel profile) async {
    ProfileController controller = Get.put(ProfileController());
    controller.editNameUser(profile);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width / 4.5,
            height: MediaQuery.of(context).size.height / 4,
            color: Colors.white,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Sửa Người Dùng", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFiewWidget(
                      color: Colors.grey,
                      hinhText: "",
                      icon: const Icon(Icons.person_outline_rounded, color: Colors.grey),
                      controller: controller.editFullNameController),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonChangeWidget(
                      colorBackgound: TColros.purple_line,
                      colorText: Colors.white,
                      text: "Lưu Thay Đổi",
                      width: 9,
                      onTap: () {
                        controller.editProfile(0, profile.uid);
                        Navigator.pop(context);
                      },
                    ),
                    ButtonChangeWidget(
                      colorBackgound: TColros.grey_cancelld,
                      colorText: Colors.white,
                      text: "Hủy",
                      width: 12,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
