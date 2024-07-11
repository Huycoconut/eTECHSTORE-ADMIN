import 'package:etech_store_admin/module/homepage/controllers/top_sale_controller.dart';
import 'package:etech_store_admin/module/homepage/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget topSale() {
  final controller = Get.put(TopSaleController());
  controller.getQuantitySale();
  return SizedBox(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: DataTable(
              dataRowMaxHeight: double.infinity,
              dividerThickness: 0.5,
              dataRowColor: MaterialStateProperty.all(Colors.transparent),
              columns: const [
                DataColumn(
                    label: Text('Tên sản phẩm',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Giá tiền',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Số lượng đã bán',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List<DataRow>.generate(
                controller.listProducts.take(5).length,
                (index) {
                  final product = controller.listProducts[index];
                  return DataRow(
                    color: MaterialStateColor.resolveWith((states) =>
                        index.isEven ? Colors.white : Colors.grey.shade200),
                    cells: [
                      DataCell(Text(product.Ten)),
                      DataCell(Text(priceFormat(product.GiaTien))),
                      DataCell(Text(product.quantity.toString())),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    ),
  );
}
