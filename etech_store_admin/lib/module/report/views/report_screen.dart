import 'package:etech_store_admin/module/report/controllers/order_controller.dart';
import 'package:etech_store_admin/module/report/controllers/print_excel.dart';
import 'package:etech_store_admin/module/report/views/bar_char.dart';
import 'package:etech_store_admin/module/report/views/date_picker.dart';
import 'package:etech_store_admin/module/report/views/stock_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    final printExcel = Get.put(PrintExcel());
    final width = MediaQuery.of(context).size.width / 1.24;
    final height = MediaQuery.of(context).size.height;
    var selectedDate = DateTime.now().obs;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Báo cáo & Thống kê',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Color(0xFF383CA0)),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Xin Chào, Admin',
                      style: TextStyle(color: Colors.white)),
                  Icon(Icons.account_circle, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          height: height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: width / 6,
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(width: 1)),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Thu nhập dự kiến',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: height / 20,
                            ),
                            Obx(() => Text(
                                  priceFormat(
                                      orderController.getExpectedEarnings()),
                                  style: const TextStyle(
                                      color: Color(0xFF383CA0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width / 50,
                      ),
                      Container(
                        width: width / 3 - 20,
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(width: 1)),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Trung bình thu nhập mỗi ngày',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: height / 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(
                                      priceFormat(orderController
                                          .getAverageDailyIncome()
                                          .toInt()),
                                      style: const TextStyle(
                                          color: Color(0xFF383CA0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                Obx(() => Container(
                                      color: orderController
                                                  .getTheIncomeDifferenceRatio() >
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                      child: Row(
                                        children: [
                                          orderController
                                                      .getTheIncomeDifferenceRatio() >
                                                  0
                                              ? const Icon(
                                                  Icons.trending_up,
                                                  color: Colors.white,
                                                )
                                              : const Icon(Icons.trending_down,
                                                  color: Colors.white),
                                          Text(
                                            '${orderController.getTheIncomeDifferenceRatio().toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                                color: Color(0xFF383CA0),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                        color: Colors.white, border: Border.all(width: 1)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => Text(
                                      softWrap: true,
                                      'Doanh thu tháng ${selectedDate.value.month}/${selectedDate.value.year}     ',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Obx(() {
                                  return Text(
                                    priceFormat(orderController.getTotalIncome(
                                        selectedDate.value.month,
                                        selectedDate.value.year)),
                                    style: const TextStyle(
                                        color: Color(0xFF383CA0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  );
                                }),
                              ],
                            ),
                            Row(
                              children: [
                                datePicker(context, selectedDate),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: IconButton(
                                      onPressed: () {
                                        printExcel.generateExcel(
                                            selectedDate.value.month,
                                            selectedDate.value.year);
                                      },
                                      icon: const Icon(Icons.print)),
                                )
                              ],
                            ),
                          ],
                        ),
                        Obx(
                          () {
                            final dayOfMonth = DateTime(selectedDate.value.year,
                                    selectedDate.value.month + 1, 0)
                                .day;
                            List<int> listIncomeByDay = [];
                            for (int day = 0; day < dayOfMonth; day += 2) {
                              listIncomeByDay.add(
                                  orderController.fetchOrdersByTime(
                                      day,
                                      selectedDate.value.month,
                                      selectedDate.value.year));
                            }
                            return AspectRatio(
                              aspectRatio: 3.5,
                              child: BarChartSalesInMonth(
                                  day: dayOfMonth,
                                  width: width,
                                  listIncome: listIncomeByDay),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: width,
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      padding: const EdgeInsets.all(8),
                      constraints:
                          const BoxConstraints(maxHeight: double.infinity),
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all(width: 1)),
                      child: Column(
                        children: [
                          const Text(
                            'Thống kê số lượng sản phẩm',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              child: tableOfStockProduct(context))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}

String priceFormat(int price) {
  final priceOutput = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return priceOutput.format(price);
}
