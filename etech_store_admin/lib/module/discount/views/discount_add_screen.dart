import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:etech_store_admin/module/discount/controller/discount_controller.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddDiscountScreen extends StatelessWidget {
  AddDiscountScreen({super.key});
  DiscountController controller = Get.put(DiscountController());
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
              title: const Text('Thêm Khuyến Mãi Mới'),
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
            body: StreamBuilder<List<ProductModel>>(
              stream: controller.getProduct(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data!;
                List<ProductModel> lstProduct = data.toList();
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1,
                        margin: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Tên Khuyến Mãi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          height: 40,
                                          child: TextField(
                                            controller: controller.newNameDisCountController,
                                            decoration: const InputDecoration(
                                              labelText: 'Nhập tên Khuyến Mãi',
                                              hintText: '',
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                              alignLabelWithHint: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Phần Trăm Khuyến Mãi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          height: 40,
                                          child: TextField(
                                            controller: controller.newPersentDisCountController,
                                            decoration: const InputDecoration(
                                              labelText: 'Nhập phần trăm khuyến mãi',
                                              hintText: '',
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                              alignLabelWithHint: true,
                                            ),
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(width: .5)),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Ngày Bắt Đầu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 5),
                                          DatePicker(
                                            minDate: DateTime(2020),
                                            maxDate: DateTime(2100),
                                            initialDate: DateTime.now(),
                                            onDateSelected: (date) {
                                              controller.startDate = date;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(width: .5)),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Ngày Kết Thúc", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 5),
                                          DatePicker(
                                            minDate: DateTime(2020),
                                            maxDate: DateTime(2100),
                                            initialDate: DateTime.now(),
                                            onDateSelected: (date) {
                                              controller.endDate = date;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(border: Border.all(width: .5)),
                                width: MediaQuery.of(context).size.width,
                                child: ExpansionTile(
                                  visualDensity: VisualDensity.compact,
                                  title: const Text("Chọn sản phẩm áp dụng"),
                                  children: [
                                    SizedBox(
                                      height: 200.0,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: lstProduct.map((product) {
                                            return ListTile(
                                              title: Container(
                                                margin: const EdgeInsets.only(right: 80),
                                                child: Text(product.ten.toString()),
                                              ),
                                              leading: Obx(() => Checkbox(
                                                    value: controller.selectedProductId.contains(product.id),
                                                    onChanged: product.KhuyenMai == 0
                                                        ? (value) {
                                                            if (value == true) {
                                                              controller.selectedProductId.add(product.id);
                                                            } else {
                                                              controller.selectedProductId.remove(product.id);
                                                            }
                                                          }
                                                        : null,
                                                  )),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  controller.saveDiscount();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: double.minPositive),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    margin: EdgeInsets.only(right: 10.w),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: const Border.fromBorderSide(BorderSide.none),
                                      color: TColros.purple_line,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Thêm sản phẩm',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(Icons.add, size: 20, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ));
      },
    );
  }
}
