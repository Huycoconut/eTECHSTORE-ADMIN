import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:etech_store_admin/module/discount/controller/discount_controller.dart';
import 'package:etech_store_admin/module/discount/model/discount_model.dart';
import 'package:etech_store_admin/module/home/view/widget/button_change_cancell_widget.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowDialogEditDisCount {
  static Future<void> showEditDiscount(BuildContext context, DiscountModel disCount) async {
    showDialog(
      context: context,
      builder: (context) {
        final DiscountController controller = Get.put(DiscountController());
        controller.initializeProduct(disCount);
        DateTime ngayBD = disCount.ngayBD.toDate();
        DateTime ngayKT = disCount.ngayKT.toDate();

        return StreamBuilder(
            stream: controller.getDiscount(),
            builder: (context, snapshotDsiCount) {
              if (!snapshotDsiCount.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<DiscountModel> lstDisCount = snapshotDsiCount.data!;
              return StreamBuilder<List<ProductModel>>(
                  stream: controller.getProductEdit(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!;
                    List<ProductModel> lstProduct = data.toList();

                    List<ProductModel> fillterProduct = lstProduct
                        .where((product) => lstDisCount
                            .any((element) => element.dsSanPham.contains(product.id) && element.id == disCount.id || product.KhuyenMai == 0))
                        .toList();

                    return Dialog(
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 1.2,
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
                                          const Center(
                                              child: Text('Thông Tin Khuyến Mãi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                                          const Divider(),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(("Tên Khuyến Mãi"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                                    const SizedBox(height: 5),
                                                    SizedBox(
                                                      height: 40,
                                                      child: TextField(
                                                        controller: controller.nameDisCountController,
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
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(("Khuyến Mãi"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            height: 40,
                                            child: TextField(
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              controller: controller.persentDisCountController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                                alignLabelWithHint: true,
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(("Thời Gian"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            child: Row(
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
                                                          selectedDate: ngayBD,
                                                          onDateSelected: (date) {
                                                            controller.startDate = date;
                                                          },
                                                          currentDateTextStyle: const TextStyle(decoration: TextDecoration.none),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets.only(right: 5),
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
                                                          selectedDate: ngayKT,
                                                          onDateSelected: (date) {
                                                            controller.endDate = date;
                                                          },
                                                          currentDateTextStyle: const TextStyle(decoration: TextDecoration.none),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            margin: const EdgeInsets.only(right: 5),
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
                                                      children: fillterProduct.map((product) {
                                                        bool isInDiscount = disCount.dsSanPham.contains(product.id);

                                                        return ListTile(
                                                          title: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context).size.width / 5,
                                                                margin: const EdgeInsets.only(right: 20),
                                                                child: Text(
                                                                  product.ten.toString(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                              isInDiscount
                                                                  ? const Text("Sản phẩm hiện có",
                                                                      style: TextStyle(color: Color.fromARGB(142, 158, 158, 158)))
                                                                  : Container()
                                                            ],
                                                          ),
                                                          leading: Obx(() => Checkbox(
                                                                value: controller.selectedProductId.contains(product.id),
                                                                onChanged: (value) {
                                                                  if (value == true) {
                                                                    controller.selectedProductId.add(product.id);
                                                                  } else {
                                                                    controller.selectedProductId.remove(product.id);
                                                                  }
                                                                },
                                                              )),
                                                          trailing: isInDiscount
                                                              ? IconButton(
                                                                  onPressed: () {
                                                                    int index = disCount.dsSanPham.indexOf(product.id);
                                                                    if (index != -1) {
                                                                      controller.removeProductInDisCount(disCount, index, product.id);
                                                                    }
                                                                  },
                                                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent))
                                                              : null,
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  controller.updateDisCount(disCount.id, disCount);
                                                  controller.saveSelectedProducts(disCount);
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width / 3,
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: const Border.fromBorderSide(BorderSide.none),
                                                    color: TColros.purple_line,
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Lưu thay đổi',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ButtonChangeWidget(
                                                colorBackgound: TColros.grey_cancelld,
                                                colorText: Colors.white,
                                                text: "Hủy",
                                                width: 9,
                                                onTap: () => Navigator.pop(context),
                                              ),
                                            ],
                                          )
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
                    );
                  });
            });
      },
    );
  }
}
