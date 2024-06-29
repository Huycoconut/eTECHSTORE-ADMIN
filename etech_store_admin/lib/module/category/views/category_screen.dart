import 'package:etech_store_admin/module/category/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catController = Get.put(CategoryController());
    TextEditingController tenDanhMuc = TextEditingController();
    TextEditingController moTa = TextEditingController();
    TextEditingController hinhAnh = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh mục sản phẩm',
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
      body: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 220,
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Thêm danh mục sản phẩm'),
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: tenDanhMuc,
                                        decoration: const InputDecoration(
                                            labelText: "Tên danh mục"),
                                      ),
                                      TextField(
                                        controller: moTa,
                                        decoration: const InputDecoration(
                                            labelText: "Mô tả"),
                                      ),
                                      TextField(
                                        controller: hinhAnh,
                                        decoration: const InputDecoration(
                                            labelText: "Icon"),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          catController.addCat(tenDanhMuc.text,
                                              moTa.value.text, hinhAnh.text);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Thêm'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Đóng'),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF383CA0)),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                              "Thêm danh mục mới",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: DataTable(
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
                          columns: const [
                            DataColumn(
                                label: Text('id',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Wrap(
                              children: [
                                Text('Tên danh mục',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )),
                            DataColumn(
                                label: Text('Mô tả',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Icon',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Trạng thái',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Thao tác',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: List<DataRow>.generate(
                              catController.listCat.length, (index) {
                            final cat = catController.listCat[index];
                            TextEditingController tenDanhMucEdit =
                                TextEditingController(text: cat.TenDanhMuc);
                            TextEditingController moTaEdit =
                                TextEditingController(text: cat.MoTa);
                            TextEditingController hinhAnhEdit =
                                TextEditingController(text: cat.HinhAnh);
                            return DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => index.isEven
                                        ? Colors.grey.shade300
                                        : Colors.white),
                                cells: [
                                  DataCell(
                                      Center(child: Text(cat.id.toString()))),
                                  DataCell(Center(child: Text(cat.TenDanhMuc))),
                                  DataCell(SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Text(cat.MoTa),
                                  )),
                                  DataCell(Center(child: Text(cat.HinhAnh))),
                                  DataCell(Switch(
                                    value: cat.TrangThai == 1 ? true : false,
                                    onChanged: (isOn) {
                                      catController.updateStatusCat(
                                          cat.TrangThai == 1 ? true : false,
                                          cat.id);
                                    },
                                    activeTrackColor: Colors.green,
                                    inactiveTrackColor: Colors.grey,
                                  )),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Sửa danh mục sản phẩm'),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3,
                                                  child: Column(
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            tenDanhMucEdit,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Tên danh mục"),
                                                      ),
                                                      TextField(
                                                        controller: moTaEdit,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Mô tả"),
                                                      ),
                                                      TextField(
                                                        controller: hinhAnhEdit,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Icon"),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          catController
                                                              .updateCat(
                                                                  tenDanhMucEdit
                                                                      .text,
                                                                  moTaEdit.text,
                                                                  hinhAnhEdit
                                                                      .text,
                                                                  cat.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Sửa'),
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
                                                          catController
                                                              .removeCat(
                                                                  cat.id);
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
                ],
              );
            },
          )),
    );
  }
}
