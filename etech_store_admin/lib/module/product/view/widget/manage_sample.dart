import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/product/model/product_sample_model.dart';
import 'package:etech_store_admin/module/product/view/widget/add_atribute_sample.dart';
import 'package:etech_store_admin/module/product/view/widget/add_configs.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSample extends StatelessWidget {
  ManageSample({super.key, required this.product, required this.sample});
  ProductModel product;
  ProductSampleModel sample;
  @override
  Widget build(BuildContext context) {
    final ProductSampleController controllerProductSample = Get.put(ProductSampleController());
    return Expanded(
      child: Container(
        decoration: BoxDecoration(border:  Border(left: BorderSide(width: .5))),
        margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
        height: MediaQuery.of(context).size.height / 1,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(child: Text('Cấu hình chi tiết', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              const Divider(),
              ProductSampleView(product: product, sample: sample),
              const SizedBox(height: 5),
              //  Obx(() => controller.variants.isNotEmpty ? const Text("Cấu hình mới") : Container()),
              const SizedBox(height: 5),
              AddConfigWidget(),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      controllerProductSample.addColors();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), border: const Border.fromBorderSide(BorderSide.none), color: TColros.purple_line),
                      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                      width: MediaQuery.of(context).size.width / 11,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Thêm Màu Sắc', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controllerProductSample.addConfigs();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), border: const Border.fromBorderSide(BorderSide.none), color: TColros.purple_line),
                      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                      width: MediaQuery.of(context).size.width / 11,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Thêm Cấu Hình', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  //   AddConfigWidget(index: 3),
                  GestureDetector(
                    onTap: () {
                      controllerProductSample.addPrices();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), border: const Border.fromBorderSide(BorderSide.none), color: TColros.purple_line),
                      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                      width: MediaQuery.of(context).size.width / 11,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Thêm Giá Tiền', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  controllerProductSample.addPrice(sample);
                  controllerProductSample.addConfig(sample);
                  controllerProductSample.addColor(sample);
                  final newPriceChange = int.tryParse(controllerProductSample.newPriceController.text);
                  if (newPriceChange != null) {
                    controllerProductSample.updatePriceInFirestore(newPriceChange, sample);
                  } else {
                    return;
                  }
                  int newPrice = int.parse(controllerProductSample.newPriceController.text);
                  controllerProductSample.updatePriceWhenHaveNot(newPrice, sample);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 6.4,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), border: const Border.fromBorderSide(BorderSide.none), color: TColros.purple_line),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Lưu thay đổi', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
