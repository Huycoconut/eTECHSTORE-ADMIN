import 'package:etech_store_admin/module/wishlist/controllers/wishlist_controller.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sản phẩm yêu thích',
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
                Text('Xin Chào, Admin', style: TextStyle(color: Colors.white)),
                Icon(Icons.account_circle, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return SizedBox(
                      child: Column(
                        children: [
                          const Text(
                            'Danh sách khách hàng',
                            style: TextStyle(
                                color: Color(0xFF383CA0), fontSize: 20),
                          ),
                          SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                  sortAscending:
                                      wishlistController.sortAscending.value,
                                  sortColumnIndex: 1,
                                  dataRowMaxHeight: double.infinity,
                                  columnSpacing:
                                      MediaQuery.of(context).size.width / 200,
                                  dividerThickness: 0,
                                  dataRowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  columns: [
                                    const DataColumn(
                                        label: Text('ID',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: const Text('Họ tên',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        onSort:
                                            wishlistController.onSortColumn),
                                    const DataColumn(
                                        label: Text('Số điện thoại',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Thao tác',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                  rows: List<DataRow>.generate(
                                      wishlistController.listWishlist.length,
                                      (index) {
                                    final wish =
                                        wishlistController.listWishlist[index];
                                    return DataRow(
                                        color: MaterialStateColor.resolveWith(
                                            (states) => index.isEven
                                                ? TColros.grey_wheat
                                                : Colors.white),
                                        cells: [
                                          DataCell(Wrap(
                                            children: [
                                              Text(wish.MaKhachHang),
                                            ],
                                          )),
                                          DataCell(Wrap(
                                            children: [
                                              Text(wishlistController
                                                  .getUserName(
                                                      wish.MaKhachHang)),
                                            ],
                                          )),
                                          DataCell(
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    '0${wishlistController.getUserPhone(wish.MaKhachHang)}')),
                                          ),
                                          DataCell(
                                            Center(
                                                child: ElevatedButton(
                                              onPressed: () {
                                                wishlistController
                                                    .getProductList(
                                                        wish.MaKhachHang);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF383CA0)),
                                              child: const Text(
                                                'Chọn',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                          )
                                        ]);
                                  })),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Obx(
                    () {
                      if (wishlistController.listProductinWish.isEmpty) {
                        return const SizedBox(
                          width: 250,
                          child: Text(
                            '''Vui lòng chọn 1 khách hàng để xem sản phẩm yêu thích của họ,\nHoặc khách hàng này chưa yêu thích sản phẩm nào''',
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Text(
                            'Sản phẩm yêu thích của ${wishlistController.getUserName(wishlistController.userIDSelected.value)}',
                            style: const TextStyle(
                                color: Color(0xFF383CA0), fontSize: 20),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              color: Colors.white,
                            ),
                            child: SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    dataRowMaxHeight: double.infinity,
                                    border: const TableBorder(
                                      verticalInside: BorderSide(
                                          width: 1, style: BorderStyle.solid),
                                      horizontalInside: BorderSide(
                                          width: 1, style: BorderStyle.solid),
                                    ),
                                    columnSpacing:
                                        MediaQuery.of(context).size.width / 200,
                                    dividerThickness: 0,
                                    dataRowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    columns: const [
                                      DataColumn(
                                          label: Text('Tên sản phẩm',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Giá tiền',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Hình ảnh',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Thao tác',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                    rows: List<DataRow>.generate(
                                        wishlistController
                                            .listProductinWish.length, (index) {
                                      final product = wishlistController
                                          .listProductinWish[index];
                                      return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                              (states) => index.isEven
                                                  ? Colors.grey.shade300
                                                  : Colors.white),
                                          cells: [
                                            DataCell(SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10,
                                                child: Text(product.Ten))),
                                            DataCell(
                                              Center(
                                                  child: Text(priceFormat(
                                                      product.GiaTien))),
                                            ),
                                            DataCell(
                                              Image.network(
                                                product.thumbnail,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10,
                                              ),
                                            ),
                                            DataCell(ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          const RoundedRectangleBorder(),
                                                      title: const Center(
                                                        child: Text(
                                                            'Xoá sản phẩm yêu thích'),
                                                      ),
                                                      content: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            8,
                                                        child: const Center(
                                                            child: Text(
                                                                'Bạn có chắc chắn muốn xoá sản phẩm này khỏi danh sách yêu thích của khách hàng này không?')),
                                                      ),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                wishlistController.removeProductinWishlist(
                                                                    product.id,
                                                                    wishlistController
                                                                        .userIDSelected
                                                                        .string);
                                                                wishlistController.getProductList(
                                                                    wishlistController
                                                                        .userIDSelected
                                                                        .string);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .redAccent),
                                                              child: const Text(
                                                                "Xác nhận",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .blueAccent),
                                                                child:
                                                                    const Text(
                                                                  "Đóng",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              child: const Text(
                                                'Xoá',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))
                                          ]);
                                    })),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

String priceFormat(int price) {
  final priceOutput = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return priceOutput.format(price);
}
