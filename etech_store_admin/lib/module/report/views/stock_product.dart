import 'package:etech_store_admin/module/report/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget tableOfStockProduct(BuildContext context) {
  final productController = Get.put(ProductController());
  return Obx(() {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: DataTable(
          dataRowMaxHeight: double.infinity,
          border: const TableBorder(
            verticalInside: BorderSide(width: 1, style: BorderStyle.solid),
            horizontalInside: BorderSide(width: 1, style: BorderStyle.solid),
          ),
          columnSpacing: MediaQuery.of(context).size.width / 200,
          dividerThickness: 0,
          dataRowColor: MaterialStateProperty.all(Colors.transparent),
          columns: const [
            DataColumn(
                label:
                    Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Tên sản phẩm',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Ngày nhập',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Giá tiền',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Trạng thái',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Số lượng',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List<DataRow>.generate(
              productController.listProduct.take(6).length, (index) {
            final product = productController.listProduct[index];
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                product.NgayNhap.millisecondsSinceEpoch);
            final quantity = productController.getQuantityOfProduct(product.id);
            return DataRow(
                color: MaterialStateColor.resolveWith((states) =>
                    index.isEven ? Colors.grey.shade300 : Colors.white),
                cells: [
                  DataCell(SizedBox(
                    width: MediaQuery.of(context).size.width / 20,
                    child: Wrap(
                      children: [
                        Text(product.id),
                      ],
                    ),
                  )),
                  DataCell(
                    Center(child: Text(product.Ten)),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                            "${dateTime.day}/${dateTime.month}/${dateTime.year}")),
                  ),
                  DataCell(
                    Center(child: Text(product.GiaTien.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                      quantity == 0
                          ? 'Hết hàng'
                          : quantity < 6
                              ? 'Sắp hết hàng'
                              : 'Còn hàng',
                      style: TextStyle(
                          color: quantity == 0
                              ? Colors.red
                              : quantity < 6
                                  ? Colors.orange
                                  : Colors.blue),
                    )),
                  ),
                  DataCell(
                    Center(child: Text(quantity.toString())),
                  ),
                ]);
          })),
    );
  });
}
