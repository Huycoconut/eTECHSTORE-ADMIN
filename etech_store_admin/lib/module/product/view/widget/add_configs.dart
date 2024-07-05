import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddConfigWidget extends StatelessWidget {
  const AddConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      AddColors(context, 1),
      const SizedBox(width: 5),
      AddConfigs(context, 2),
      const SizedBox(width: 5),
      AddPrices(context, 3),
    ]);
  }

  Widget AddColors(BuildContext context, int index) {
    final ProductSampleController controller = Get.put(ProductSampleController());
    return Obx(
      () => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: controller.variantColors.map((variant) {
            int index = controller.variantColors.indexOf(variant);
            return Container(
              margin: const EdgeInsets.only(bottom: 7),
              height: 40,
              child: TextField(
                controller: variant['MauSac'],
                decoration: InputDecoration(
                  labelText: 'Màu sắc',
                  hintText: '',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.removeVariantColors(index);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget AddConfigs(BuildContext context, int index) {
    final ProductSampleController controller = Get.put(ProductSampleController());
    return Obx(
      () => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: controller.variantConfigs.map((variant) {
            int index = controller.variantConfigs.indexOf(variant);
            return Container(
              margin: const EdgeInsets.only(bottom: 7),
              height: 40,
              child: TextField(
                controller: variant['CauHinh'],
                decoration: InputDecoration(
                  labelText: 'Cấu Hình',
                  hintText: '',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.removeVariantConfigs(index);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget AddPrices(BuildContext context, int index) {
    final ProductSampleController controller = Get.put(ProductSampleController());
    return Obx(
      () => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: controller.variantPrices.map((variant) {
            int index = controller.variantPrices.indexOf(variant);
            return Container(
              margin: const EdgeInsets.only(bottom: 7),
              height: 40,
              child: TextField(
                controller: variant['GiaTien'],
                decoration: InputDecoration(
                  labelText: 'Giá Tiền',
                  hintText: '',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.removeVariantPridces(index);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
