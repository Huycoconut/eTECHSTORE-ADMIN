import 'package:etech_store_admin/module/report/controllers/order_controller.dart';
import 'package:etech_store_admin/module/report/controllers/print_excel.dart';
import 'package:etech_store_admin/module/report/views/bar_char.dart';
import 'package:etech_store_admin/module/report/views/date_picker.dart';
import 'package:etech_store_admin/module/report/views/pie_char.dart';
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width / 3 - 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1)),
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
                      Container(
                        width: width / 3 - 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1)),
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
                      Container(
                        width: width / 3 - 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1)),
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
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: [
                      SizedBox(
                        width: width / 2.5 - 30,
                        height: height / 2,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(
                                        softWrap: true,
                                        'Doanh thu tháng ${selectedDate.value.month}/${selectedDate.value.year}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                    children: [
                                      datePicker(context, selectedDate),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 0),
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
                              Obx(
                                () {
                                  final RxDouble weak1 = orderController
                                      .getIncome1to7(selectedDate.value.month,
                                          selectedDate.value.year)
                                      .obs;
                                  final RxDouble weak2 = orderController
                                      .getIncome8to14(selectedDate.value.month,
                                          selectedDate.value.year)
                                      .obs;
                                  final RxDouble weak3 = orderController
                                      .getIncome15to21(selectedDate.value.month,
                                          selectedDate.value.year)
                                      .obs;
                                  final RxDouble weak4 = orderController
                                      .getIncome22to28(selectedDate.value.month,
                                          selectedDate.value.year)
                                      .obs;
                                  final RxDouble extant = orderController
                                      .getIncome29toEnd(
                                          selectedDate.value.month,
                                          selectedDate.value.year)
                                      .obs;
                                  return AspectRatio(
                                    aspectRatio: 1.6,
                                    child: BarChartSalesInMonth(
                                      weak1: weak1.toDouble(),
                                      weak2: weak2.toDouble(),
                                      weak3: weak3.toDouble(),
                                      weak4: weak4.toDouble(),
                                      extant: extant.toDouble(),
                                      width: width,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //     width: width / 3,
                      //     height: height / 2.1,
                      //     padding: const EdgeInsets.all(8),
                      //     margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: const PieChartSample2()),
                      Container(
                          width: width * 0.6 - 20,
                          height: height / 2,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1)),
                          child: Column(
                            children: [
                              const Text(
                                'Thống kê số lượng sản phẩm',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1)),
                                  child: tableOfStockProduct(context))
                            ],
                          )),
                    ],
                  ),
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
