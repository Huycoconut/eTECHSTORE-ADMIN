import 'package:etech_store_admin/module/order/view/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/report/controllers/order_controller.dart';
import 'package:get/get.dart';
import 'package:excel/excel.dart';

class PrintExcel extends GetxController {
  static PrintExcel get instance => Get.find();

  final orderController = Get.put(OrderController());
  Future<void> generateExcel(int month, int year) async {
    var rowIndex = 2;
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet() as String];
    sheet!.setColumnAutoFit(1);
    sheet.setColumnAutoFit(2);
    sheet.setColumnAutoFit(3);
    sheet.setColumnAutoFit(4);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =
        const TextCellValue('ID');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value =
        const TextCellValue('Mã khách hàng');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1)).value =
        const TextCellValue('Tổng tiền');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1)).value =
        const TextCellValue('Ngày tạo đơn');
    await orderController.getOrderByMonth(month, year);
    for (var order in orderController.listOrderByTime) {
      if (order.isCompleted) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(order.id);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(order.MaKhachHang);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(priceFormat(order.TongTien));
        sheet
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: 4, rowIndex: rowIndex))
                .value =
            TextCellValue(
                '${order.NgayTaoDon.toDate().day}/${order.NgayTaoDon.toDate().month}/${order.NgayTaoDon.toDate().year}');
        rowIndex++;
        // if (rowIndex > orderController.listOrderByTime.length) {
        //   return;
        // }
      }
    }

    excel.save(fileName: "eTECHSTOREDoanhThu${month}_$year.xlsx");
  }
}
