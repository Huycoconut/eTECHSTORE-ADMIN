import 'package:etech_store_admin/module/home/view/home_screen_desktop.dart';
import 'package:etech_store_admin/module/homepage/views/order_view.dart';
import 'package:etech_store_admin/module/homepage/views/top_sale.dart';
import 'package:etech_store_admin/module/report/controllers/order_controller.dart';
import 'package:etech_store_admin/module/report/controllers/print_excel.dart';
import 'package:etech_store_admin/module/report/views/bar_char.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            'Trang Chủ',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width / 6,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1)),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Thu nhập dự kiến',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: height / 45,
                                ),
                                Obx(() => Text(
                                      priceFormat(orderController
                                          .getExpectedEarnings()),
                                      style: const TextStyle(
                                          color: Color(0xFF383CA0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1)),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Trung bình thu nhập mỗi ngày',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: height / 45,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Obx(() => Container(
                                          color: orderController
                                                      .getTheIncomeDifferenceRatio() >
                                                  0
                                              ? const Color.fromARGB(
                                                  255, 140, 192, 142)
                                              : const Color.fromARGB(
                                                  255, 223, 142, 136),
                                          child: Row(
                                            children: [
                                              orderController
                                                          .getTheIncomeDifferenceRatio() >
                                                      0
                                                  ? const Icon(
                                                      Icons.trending_up,
                                                      color: Colors.green,
                                                    )
                                                  : const Icon(
                                                      Icons.trending_down,
                                                      color: Colors.red),
                                              Text(
                                                '  ${orderController.getTheIncomeDifferenceRatio().toStringAsFixed(1)}%',
                                                style: TextStyle(
                                                    color: orderController
                                                                .getTheIncomeDifferenceRatio() >
                                                            0
                                                        ? Colors.green
                                                        : Colors.red,
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
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        width: width,
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
                                        priceFormat(
                                            orderController.getTotalIncome(
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
                                TextButton(
                                    onPressed: () {
                                      Get.offAll(
                                          HomeScreenDesktop(selectedIndex: 6));
                                    },
                                    child: const Text('Xem chi tiết'))
                              ],
                            ),
                            Obx(
                              () {
                                final dayOfMonth = DateTime(
                                        selectedDate.value.year,
                                        selectedDate.value.month + 1,
                                        0)
                                    .day;
                                List<int> listIncomeByDay = [];
                                listIncomeByDay.clear();
                                for (int day = 1; day < dayOfMonth; day++) {
                                  listIncomeByDay.add(
                                      orderController.fetchOrdersByTime(
                                          day,
                                          selectedDate.value.month,
                                          selectedDate.value.year));
                                }
                                return AspectRatio(
                                  aspectRatio: 4,
                                  child: BarChartSalesInMonth(
                                      width: width,
                                      listIncome: listIncomeByDay),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                    height: 8,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Tình trạng đơn hàng',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  TextButton(
                                      onPressed: () {
                                        Get.offAll(HomeScreenDesktop(
                                            selectedIndex: 2));
                                      },
                                      child: const Text('Xem chi tiết')),
                                ],
                              ),
                              SizedBox(
                                  width: width / 2 - 8,
                                  height: height / 2.9,
                                  child: orderView()),
                            ],
                          ),
                        ),
                        Container(
                            width: width / 2,
                            height: height / 2.56,
                            margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                const Text('Top 5 sản phẩm bán chạy',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Obx(() => topSale())),
                              ],
                            )),
                      ],
                    ),
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
