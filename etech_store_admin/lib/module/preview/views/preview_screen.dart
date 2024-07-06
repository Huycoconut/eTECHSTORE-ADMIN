import 'package:etech_store_admin/module/preview/controllers/preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final previewController = Get.put(PreviewController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đánh giá sản phẩm',
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
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Obx(
            () {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.white,
                      ),
                      child: DataTable(
                          sortColumnIndex: 4,
                          sortAscending: previewController.sortAscending.value,
                          dataRowMaxHeight: double.infinity,
                          border: const TableBorder(
                            verticalInside:
                                BorderSide(width: 1, style: BorderStyle.solid),
                            horizontalInside:
                                BorderSide(width: 1, style: BorderStyle.solid),
                          ),
                          columnSpacing:
                              MediaQuery.of(context).size.width / 200,
                          dividerThickness: 0,
                          dataRowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          columns: [
                            const DataColumn(
                                label: Text('Đánh giá',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text('Số sao',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text('Khách hàng',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const DataColumn(
                                label: Text('Sản phẩm',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: const Text('Trạng thái',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onSort: previewController.onSortColumn),
                            const DataColumn(
                                label: Text('Thao tác',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: List<DataRow>.generate(
                              previewController.listpreviews.length, (index) {
                            final preview =
                                previewController.listpreviews[index];
                            return DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => index.isEven
                                        ? Colors.grey.shade300
                                        : Colors.white),
                                cells: [
                                  DataCell(SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Wrap(
                                      children: [
                                        Text(preview.DanhGia),
                                      ],
                                    ),
                                  )),
                                  DataCell(Center(
                                      child: Text(preview.SoSao.toString()))),
                                  DataCell(Center(
                                    child: Text(previewController
                                        .getUserName(preview.MaKhachHang)),
                                  )),
                                  DataCell(Text(previewController
                                      .getProductName(preview.MaSanPham))),
                                  DataCell(Builder(
                                    builder: (context) {
                                      if (preview.TrangThai == true) {
                                        return const Center(
                                          child: Text(
                                            'Đã duyệt',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: Text(
                                            'Chưa duyệt',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                      }
                                    },
                                  )),
                                  DataCell(Row(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            preview.TrangThai == false
                                                ? showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Duyệt đánh giá này'),
                                                        content: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                          child: const Center(
                                                              child: Text(
                                                                  'Bạn có chắc chắn muốn duyệt đánh giá này không?')),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  previewController
                                                                      .approvePreview(
                                                                          preview
                                                                              .id);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Duyệt'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Đóng'),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : null;
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  preview.TrangThai == false
                                                      ? const Color(0xFF383CA0)
                                                      : Colors.grey),
                                          child: const Text(
                                            "Duyệt đánh giá",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Xoá danh mục sản phẩm'),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3,
                                                  child: const Center(
                                                      child: Text(
                                                          'Bạn có chắc chắn muốn xoá danh mục sản phẩm này')),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          previewController
                                                              .removePreview(
                                                                  preview.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Xoá'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Đóng'),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                                ]);
                          })),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
