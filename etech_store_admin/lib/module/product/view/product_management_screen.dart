import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/oerder_manage/view/desktop/order_manage_screen_desktop.dart';
import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/model/categories_model.dart';
import 'package:etech_store_admin/module/product/model/product_sample_model.dart';
import 'package:etech_store_admin/module/product/view/product_edit_screen.dart';
import 'package:etech_store_admin/module/product/view/widget/pagination_product_widget.dart';
import 'package:etech_store_admin/module/product/view/widget/show_bottom_sheet_widget.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/product_model.dart';

class ProductManageDesktopScreen extends StatelessWidget {
  ProductManageDesktopScreen({super.key});

  ProductController controller = Get.put(ProductController());
  ProductSampleController controllerSample = Get.put(ProductSampleController());

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        title: const Text('Quản Lý Sản Phẩm'),
        backgroundColor: Colors.red,
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
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            const Text(
              "Tìm Kiếm Sản Phẩm",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm kiếm Tên Sản Phẩm',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchProductName.value = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm kiếm Loại Sản Phẩm',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchCategory.value = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm kiếm Giá Tiền',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchPrice.value = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<ProductSampleModel>>(
                stream: controller.getSampleProduct(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<ProductSampleModel> lstSample = snapshot.data!;
                    return StreamBuilder<List<CategoryModel>>(
                      stream: controller.getCategories(),
                      builder: (context, categorySnapshot) {
                        if (categorySnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (categorySnapshot.hasError) {
                          return Center(child: Text('Lỗi: ${categorySnapshot.error}'));
                        }
                        if (!categorySnapshot.hasData || categorySnapshot.data!.isEmpty) {
                          return const Center(child: Text('Không có danh mục'));
                        }
                        List<CategoryModel> lstCategory = categorySnapshot.data!;
                        return StreamBuilder<List<ProductModel>>(
                          stream: controller.getProduct(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (productSnapshot.hasError) {
                              return Center(child: Text('Lỗi: ${productSnapshot.error}'));
                            }
                            if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                              return const Center(child: Text('Không có dữ liệu'));
                            }

                            List<ProductModel> products = productSnapshot.data!;
                            List<ProductModel> lstProduct = products.where((element) => element.trangThai == true).toList();

                            return Obx(() {
                              // Lọc danh sách sản phẩm dựa trên các tiêu chí tìm kiếm
                              List<ProductModel> filteredProducts = lstProduct.where((product) {
                                final category = lstCategory.firstWhere((cat) => cat.id == product.maDanhMuc);
                                bool matchesName = product.ten.toLowerCase().contains(controller.searchProductName.value.toLowerCase());
                                bool matchesCategory = category.TenDanhMuc.toLowerCase().contains(controller.searchCategory.value.toLowerCase());
                                bool matchesPrice =
                                    controller.searchPrice.value.isEmpty || product.giaTien.toString() == controller.searchPrice.value;
                                return matchesName && matchesCategory && matchesPrice;
                              }).toList();
                              //
                              if (controller.searchProductName.value.isEmpty &&
                                  controller.searchCategory.value.isEmpty &&
                                  controller.searchPrice.value.isEmpty) {
                                filteredProducts = controller.allProducts;
                              }
                              // Phân trang danh sách sản phẩm
                              int startIndex = (controller.currentPage.value - 1) * controller.itemsPerPage.value;
                              int endIndex = startIndex + controller.itemsPerPage.value;
                              List<ProductModel> paginatedProducts = filteredProducts.sublist(startIndex, endIndex.clamp(0, filteredProducts.length));

                              return Column(
                                children: [
                                  SingleChildScrollView(
                                    child: DataTable(
                                      dataRowHeight: 100,
                                      horizontalMargin: 50,
                                      headingRowHeight: 30,
                                      dividerThickness: 0,
                                      dataRowColor: MaterialStateProperty.all(Colors.transparent),
                                      columns: [
                                        DataColumn(
                                            label: Padding(
                                          padding: EdgeInsets.only(left: media.width * 0.0009, right: media.width / 160),
                                          child: const Text('STT', style: TextStyle(fontWeight: FontWeight.bold)),
                                        )),
                                        DataColumn(
                                            label: Padding(
                                                padding: EdgeInsets.only(left: media.width / 30, right: media.width / 100),
                                                child: const Text('Ảnh', style: TextStyle(fontWeight: FontWeight.bold)))),
                                        DataColumn(
                                            label: Padding(
                                                padding: EdgeInsets.only(left: media.width / 40, right: media.width / 100),
                                                child: const Text('Tên Sản Phẩm', style: TextStyle(fontWeight: FontWeight.bold)))),
                                        const DataColumn(
                                            label: Padding(
                                                padding: EdgeInsets.only(right: 40.0),
                                                child: Text('Loại Sản Phẩm', style: TextStyle(fontWeight: FontWeight.bold)))),
                                        const DataColumn(label: Text('Giá Gốc', style: TextStyle(fontWeight: FontWeight.bold))),
                                        DataColumn(
                                            label: Padding(
                                                padding: EdgeInsets.only(right: media.width / 50.0),
                                                child: const Text('Khuyến Mãi', style: TextStyle(fontWeight: FontWeight.bold)))),
                                        const DataColumn(label: Text('Thao Tác', style: TextStyle(fontWeight: FontWeight.bold))),
                                      ],
                                      rows: List<DataRow>.generate(paginatedProducts.length, (index) {
                                        String categoryName = controller.categoryMap[paginatedProducts[index].maDanhMuc] ?? 'Unknown';

                                        final product = paginatedProducts[index];
                                        final categories = lstCategory.firstWhere((element) => element.id == product.maDanhMuc);
                                        final sample = lstSample.firstWhere((element) => element.MaSanPham == product.id);
                                        return DataRow(
                                          color: MaterialStateColor.resolveWith((states) => index.isEven ? Colors.white : Colors.grey[200]!),
                                          cells: <DataCell>[
                                            DataCell(Padding(
                                                padding: EdgeInsets.only(left: 5, right: media.width / 100),
                                                child: Text((index + 1 + startIndex).toString()))),
                                            DataCell(Container(
                                                color: Colors.transparent,
                                                 width: media.width / 15,
                                                height: media.width / 20,
                                                child: Image.network(paginatedProducts[index].thumbnail, fit: BoxFit.fill))),
                                            DataCell(Padding(
                                                padding: EdgeInsets.only(left: media.width / 40, right: media.width / 40),
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth: media.width / 8),
                                                    child: Text(paginatedProducts[index].ten, overflow: TextOverflow.clip)))),
                                            DataCell(Padding(padding: EdgeInsets.only(left: media.width / 200.0), child: Text(categoryName))),
                                            DataCell(  Text(priceFormat(paginatedProducts[index].giaTien))),
                                            DataCell(Padding(
                                                padding: EdgeInsets.only(left: media.width / 50.0),
                                                child: Text('${paginatedProducts[index].KhuyenMai}%'))),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                                    onPressed: () {
                                                      ShowDialog.showDetailPorduct(context, categories, product, sample);
                                                      controllerSample.showActribute.value = false;
                                                      controller.setDefault();
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete, color: Colors.red),
                                                    onPressed: () {
                                                      TLoaders.showConfirmPopup(
                                                          title: "Cảnh báo",
                                                          description: "Xác nhận xóa không thể khôi phục!",
                                                          onDismissed: () => Container(),
                                                          conFirm: () => FirebaseFirestore.instance
                                                              .collection("SanPham")
                                                              .doc(product.id)
                                                              .update({'TrangThai': false}));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Pagination(
                                    currentPage: controller.currentPage.value,
                                    itemsPerPage: controller.itemsPerPage.value,
                                    totalItems: lstProduct.length,
                                    onPageChanged: (page) => controller.updatePage(page),
                                  ),
                                ],
                              );
                            });
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
