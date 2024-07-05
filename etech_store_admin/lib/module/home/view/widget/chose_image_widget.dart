import 'dart:io';

import 'package:etech_store_admin/module/home/controller/user_management_cotroller.dart';
import 'package:etech_store_admin/module/profile/controller/profile_controller.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChoseImageWidget extends StatefulWidget {
  const ChoseImageWidget({super.key});

  @override
  State<ChoseImageWidget> createState() => _ChoseImageWidgetState();
}

class _ChoseImageWidgetState extends State<ChoseImageWidget> {
  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(
            () => controller.thumbnailBytes.value != null
                ? SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.memory(
                        controller.thumbnailBytes.value!,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            height: 20,
                            width: 20,
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(width: .5)),
                    width: 90,
                    height: 90,
                    child: const Icon(Icons.person_outline_outlined, size: 65, weight: 2)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                controller.pickThumbnail();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(width: .5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text('Chọn ảnh'),
            ),
          ),
        ],
      ),
    );
  }
}
