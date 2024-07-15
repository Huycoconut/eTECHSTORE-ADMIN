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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ShowDialog {
  static Future<void> showDetailPorduct(BuildContext context, CategoryModel category, ProductModel product, ProductSampleModel sample) async {
    showDialog(
      context: context,
      builder: (context) {
        final ProductController controller = Get.put(ProductController());
        final ProductSampleController controllerprductSample = Get.put(ProductSampleController());
        controller.initializeProduct(product);
        controllerprductSample.initQuantiry(sample);
        controller.selectedCategory.value = category.id;
        return Dialog(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1,
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          margin: const EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Center(child: Text('Thông tin sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                                const Divider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(("Tên Sản Phẩm"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              onChanged: (value) {
                                                //  controller.nameController.text = value;
                                              },
                                              controller: controller.nameController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                                alignLabelWithHint: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(("Loại Sản Phẩm"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 5),
                                          Container(
                                              width: MediaQuery.of(context).size.width / 2,
                                              height: 40,
                                              decoration: BoxDecoration(border: Border.all(width: .5), borderRadius: BorderRadius.circular(4)),
                                              child: Obx(
                                                () => DropdownButton<int>(
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  padding: const EdgeInsets.all(10),
                                                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                  value: controller.selectedCategory.value,
                                                  items: controller.categories.map((category) {
                                                    return DropdownMenuItem<int>(
                                                      value: category.id,
                                                      child: Text(category.TenDanhMuc),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      controller.selectedCategory.value = value;
                                                    }
                                                  },
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(("Giá"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              controller: controller.priceController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                                alignLabelWithHint: true,
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(("Số Lượng"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              controller: controllerprductSample.soLuongController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                                alignLabelWithHint: true,
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text("Ảnh Bìa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                Container(
                                    decoration: BoxDecoration(border: Border.all(width: .5)),
                                    height: 30,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await controller.pickThumbnail();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              border: Border(right: BorderSide(width: .5)),
                                              color: Color.fromARGB(86, 220, 218, 218),
                                            ),
                                            child: const Text("Chọn tệp"),
                                          ),
                                        ),
                                        Obx(
                                          () => Container(
                                            height: 40,
                                            padding: const EdgeInsets.only(left: 10),
                                            alignment: Alignment.center,
                                            child: controller.thumbnailBytes.value == null
                                                ? const Text("Không có tệp nào được chọn")
                                                : const Text("1 tệp đã được chọn"),
                                          ),
                                        )
                                      ],
                                    )),
                                Row(
                                  children: [
                                    Obx(
                                      () => controller.thumbnailBytes.value == null
                                          ? Container(
                                              margin: const EdgeInsets.only(top: 7),
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                              ),
                                              child: Image.network(
                                                product.thumbnail,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : Obx(() => Container(
                                                margin: const EdgeInsets.only(top: 7),
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                ),
                                                child: Image.memory(
                                                  controller.thumbnailBytes.value!,
                                                  height: 100,
                                                  width: 100,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      margin: const EdgeInsets.all(5),
                                                      height: 100,
                                                      width: 100,
                                                      color: Colors.grey,
                                                      child: const Center(
                                                        child: Icon(Icons.error, color: Colors.red),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text("Cấu hình chi tiết", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    controllerprductSample.changeAtribute();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: const Border.fromBorderSide(BorderSide.none),
                                        color: TColros.purple_line),
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    width: MediaQuery.of(context).size.width / 11,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        sample.giaTien.isEmpty
                                            ? const Text('Thêm Cấu Hình', style: TextStyle(color: Colors.white))
                                            : const Text('Xem Cấu Hình', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text("Ảnh Sản Phẩm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                Container(
                                    decoration: BoxDecoration(border: Border.all(width: .5)),
                                    height: 30,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await controller.pickImages();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              border: Border(right: BorderSide(width: .5)),
                                              color: Color.fromARGB(86, 220, 218, 218),
                                            ),
                                            child: const Text("Chọn tệp"),
                                          ),
                                        ),
                                        Obx(
                                          () => Container(
                                            height: 40,
                                            padding: const EdgeInsets.only(left: 10),
                                            alignment: Alignment.center,
                                            child: controller.uploadedImageBytes.isNotEmpty
                                                ? Text("${controller.uploadedImageBytes.length} tệp nào được chọn")
                                                : const Text("Không có tệp nào được chọn"),
                                          ),
                                        )
                                      ],
                                    )),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => controller.uploadedImageBytes.isNotEmpty ? const Text("Ảnh hiện tại") : Container()),
                                    Wrap(
                                      children: product.hinhAnh.map((e) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 7, bottom: 7),
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                  ),
                                                  child: Image.network(
                                                    e,
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        color: Colors.grey,
                                                        child: const Center(
                                                          child: Icon(Icons.error, color: Colors.red),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 2,
                                                    left: 65,
                                                    bottom: 75,
                                                    child: IconButton(
                                                        color: Colors.redAccent,
                                                        onPressed: () async {
                                                          int indexToRemove = product.hinhAnh.indexOf(e);
                                                          if (indexToRemove != -1) {
                                                            product.hinhAnh.removeAt(indexToRemove);
                                                          }
                                                          await FirebaseFirestore.instance
                                                              .collection('SanPham')
                                                              .doc(product.id)
                                                              .update({'DSHinhAnh': product.hinhAnh});
                                                          controller.uploadedImageNames.removeAt(e);
                                                        },
                                                        icon: const Icon(Icons.remove_circle_outlined))),
                                              ],
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                Obx(() => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        controller.uploadedImageBytes.isNotEmpty ? const Text("Ảnh mới") : Container(),
                                        Wrap(
                                          children: controller.uploadedImageBytes.map((imageBytes) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 7, bottom: 7),
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey),
                                                  ),
                                                  child: Image.memory(
                                                    imageBytes,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        color: Colors.grey,
                                                        child: const Center(
                                                          child: Icon(Icons.error, color: Colors.red),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 2,
                                                    left: 65,
                                                    bottom: 75,
                                                    child: IconButton(
                                                        color: TColros.purple_line,
                                                        onPressed: () {
                                                          controller.uploadedImageBytes.remove(imageBytes);
                                                        },
                                                        icon: const Icon(Icons.remove_circle_outlined))),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 10),
                                const Text(("Mô Tả"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 150,
                                  child: TextField(
                                    onChanged: (value) {
                                      //    controller.descriptionController.text = value;
                                    },
                                    maxLines: 6,
                                    textAlign: TextAlign.left,
                                    textAlignVertical: TextAlignVertical.top,
                                    controller: controller.descriptionController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    controller.updateProduct(product.id, product);
                                    controllerprductSample.updateQuantitySample(sample.id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: double.minPositive),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 6.4,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: const Border.fromBorderSide(BorderSide.none),
                                        color: TColros.purple_line,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Lưu thay đổi',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      controllerprductSample.showActribute.value
                          ? ManageSample(
                              product: product,
                              sample: sample,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
