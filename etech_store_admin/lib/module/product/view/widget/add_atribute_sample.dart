import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/product/model/product_sample_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProductSampleView extends StatelessWidget {
  ProductSampleView({super.key, required this.product, required this.sample});
  ProductModel product;
  ProductSampleModel sample;
  @override
  Widget build(BuildContext context) {
    final ProductSampleController controller = Get.put(ProductSampleController());

    // Gán chỉ số màu sắc và cấu hình mặc định
    controller.setSelectedColorIndex(0, sample);
    controller.setSelectedConfigIndex(0, sample);
    return StreamBuilder<List<ProductSampleModel>>(
      stream: controller.getSampleProduct(),
      builder: (context, snapshot) {
        List<ProductSampleModel> lstSample = snapshot.data!;
        List fillterSample = lstSample.where((element) => element.MaSanPham == product.id).toList();
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: fillterSample.length,
          itemBuilder: (context, index) {
            sample = fillterSample[index];
            return Obx(
              () => ListView(
                shrinkWrap: true,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Màu Sắc',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: sample.mauSac.asMap().entries.map((entry) {
                      int index = entry.key;
                      String color = entry.value;
                      return ListTile(
                        title: Text(color),
                        trailing: Radio<int>(
                          value: index,
                          groupValue: controller.selectedColorIndex.value,
                          onChanged: (int? value) {
                            if (value != null) {
                              controller.setSelectedColorIndex(value, sample);
                              controller.checkPrice(sample);
                            }
                          },
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.remove_circle_outline_sharp, color: Colors.redAccent),
                          onPressed: () {
                            controller.removeColorFromFirestore(sample, index);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cấu Hình',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: sample.cauHinh.asMap().entries.map((entry) {
                      int index = entry.key;
                      String config = entry.value;
                      return ListTile(
                        title: Text(config),
                        trailing: Radio<int>(
                          value: index,
                          groupValue: controller.selectedConfigIndex.value,
                          onChanged: (int? value) {
                            if (value != null) {
                              controller.setSelectedConfigIndex(value, sample);
                              controller.checkPrice(sample);
                            }
                          },
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.remove_circle_outline_sharp, color: Colors.redAccent),
                          onPressed: () {
                            controller.removeConfigFromFirestore(sample, index);
                          },
                        ),
                      );
                    }).toList(),
                  ), // Hiển thị giá tiền
                  Obx(() => 
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: 
                          Text(
                              'Giá Tiền: ${controller.displayedPrice.value}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        
                          ),
                        ),
                        sample.giaTien.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.remove_circle_outline_sharp, color: Colors.redAccent),
                                onPressed: () {
                                  controller.removePriceFromFirestore(sample, index);
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),

                  // Nhập giá tiền mới
                  sample.giaTien.isNotEmpty
                      ? TextField(
                          controller: controller.newPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Thay Đổi Giá Tiền',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Container(),
                  if (controller.currentPrice.value == 'Không có giá')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.newPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Nhập giá tiền',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),

                  // Nút cập nhật giá tiền
                ],
              ),
            );
          },
        );
      },
    );
  }
}
