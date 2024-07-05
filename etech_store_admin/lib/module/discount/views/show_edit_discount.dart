import 'package:etech_store_admin/module/discount/controller/discount_controller.dart';
import 'package:etech_store_admin/module/discount/model/discount_model.dart';
import 'package:etech_store_admin/module/home/view/widget/button_change_cancell_widget.dart';
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
        return Dialog(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 2.3,
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
                                const Center(child: Text('Thông Tin Khuyến Mãi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
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
                                const SizedBox(height: 10),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(("Ngày Bắt Đầu: "), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          controller.selectedStartDate == null
                                              ? Text(DateFormat('dd-MM-yyyy').format(disCount.ngayBD.toDate()))
                                              : Text(
                                                  "${controller.selectedStartDate!.day.toString().padLeft(2, '0')}-${controller.selectedStartDate!.month.toString().padLeft(2, '0')}-${controller.selectedStartDate!.year.toString()}",
                                                ),
                                        ],
                                      ),
                                      Container(
                                        height: 15,
                                        width: 1,
                                        color: Colors.black,
                                        margin: const EdgeInsets.symmetric(horizontal: 15),
                                      ),
                                 
                                      Row(
                                          children: [
                                            const Text(("Ngày Kết Thúc: "), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                            controller.selectedStartDate == null
                                                ? Text(DateFormat('dd-MM-yyyy').format(disCount.ngayKT.toDate()))
                                                : Text(
                                                    "${controller.selectedEndDate!.day.toString().padLeft(2, '0')}-${controller.selectedEndDate!.month.toString().padLeft(2, '0')}-${controller.selectedEndDate!.year.toString()}",
                                                  ),
                                          ],
                                        ),
                                     
                                      Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        width: 40,
                                        child: Expanded(
                                          child: IconButton(
                                              onPressed: () {
                                                controller.showDatePicker(context, disCount);
                                              },
                                              icon: const Icon(Icons.calendar_month_rounded)),
                                        ),
                                      )
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
                                        print("object");
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 5,
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
                                      width: 11,
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
       
      },
    );
  }
}
