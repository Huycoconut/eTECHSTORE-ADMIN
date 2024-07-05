import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/discount/controller/discount_controller.dart';
import 'package:etech_store_admin/module/discount/model/discount_model.dart';
import 'package:etech_store_admin/module/discount/views/show_edit_discount.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DisCountScreen extends StatelessWidget {
  const DisCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DiscountController controller = Get.put(DiscountController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản Lý Khuyến Mãi',
          style: TextStyle(color: Colors.white),
        ),
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
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: StreamBuilder<List<DiscountModel>>(
            stream: controller.getDiscount(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<DiscountModel> lstDisCount = snapshot.data!;
              List<DiscountModel> statusDisCount = lstDisCount.where((element) => element.trangThai == 1).toList();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        dataRowMaxHeight: 70,
                        columns: const [
                          DataColumn(label: SizedBox(width: 30, child: Text('STT', style: TextStyle(fontWeight: FontWeight.bold)))),
                          DataColumn(label: Text('Tên Chương Trình', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Khuyến Mãi', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: SizedBox(width: 100, child: Text('Ngày Bắt Đầu', style: TextStyle(fontWeight: FontWeight.bold)))),
                          DataColumn(label: Text('Ngày Kết Thúc', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: List<DataRow>.generate(
                          statusDisCount.length,
                          (index) => DataRow(
                            color: MaterialStateColor.resolveWith((states) => index.isEven ? Colors.white : Colors.grey[200]!),
                            cells: [
                              DataCell(SizedBox(width: 10, child: Text((index + 1).toString()))),
                              DataCell(SizedBox(width: 150, child: Text(statusDisCount[index].ten))),
                              DataCell(Center(child: SizedBox(width: 150, child: Text("${statusDisCount[index].phanTramKhuyenMai.toString()}%")))),
                              DataCell(Text(DateFormat('dd-MM-yyyy').format(statusDisCount[index].ngayBD.toDate()))),
                              DataCell(Text(DateFormat('dd-MM-yyyy').format(statusDisCount[index].ngayKT.toDate()))),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        ShowDialogEditDisCount.showEditDiscount(context, lstDisCount[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        TLoaders.showConfirmPopup(
                                            title: "Cảnh báo",
                                            description: "Xác nhận xóa không thể khôi phục!",
                                            onDismissed: () => Container(),
                                            conFirm: () => controller.updateStatusDisCount(lstDisCount[index].id, lstDisCount[index]));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
