import 'package:etech_store_admin/module/product/controller/product_controller.dart';
import 'package:etech_store_admin/module/product/controller/product_sample_controller.dart';
import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/product/view/widget/add_attribute_sample_widget.dart';
import 'package:etech_store_admin/module/product/view/widget/add_configs.dart';
import 'package:etech_store_admin/module/product/view/widget/manage_sample.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  final ProductSampleController controllerProductSample = Get.put(ProductSampleController());

  AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            title: const Text('Thêm Sản Phẩm Mới'),
            backgroundColor: TColros.purple_line,
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
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Container(
                       height: MediaQuery.of(context).size.height / 1,
                       margin: const EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(("Tên Sản Phẩm"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        height: 40,
                                        child: TextField(
                                          controller: productController.nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Tên sản phẩm',
                                            hintText: '',
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                            alignLabelWithHint: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(("Loại Sản Phẩm"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 5),
                                      Obx(() => Container(
                                            width: MediaQuery.of(context).size.width / 2,
                                            height: 42,
                                            decoration: BoxDecoration(border: Border.all(width: .5), borderRadius: BorderRadius.circular(4)),
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              padding: const EdgeInsets.all(10),
                                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                              value: productController.selectedCategory.value,
                                              items: productController.categories.map((category) {
                                                return DropdownMenuItem<int>(
                                                  value: category.id,
                                                  child: Text(category.TenDanhMuc),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  productController.selectedCategory.value = value;
                                                }
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(("Giá"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 40,
                              child: TextField(
                                controller: productController.priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Giá tiền',
                                  hintText: '',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                  alignLabelWithHint: true,
                                ),inputFormatters: [FilteringTextInputFormatter.digitsOnly] ,
                        
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(("Cấu Hinh Chi Tiết"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                controllerProductSample.addAtributeProduct();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: const Border.fromBorderSide(BorderSide.none),
                                    color: TColros.purple_line),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                width: MediaQuery.of(context).size.width / 18.5,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Thêm',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(Icons.add, size: 20, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("Ảnh Bìa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Container(
                                decoration: BoxDecoration(border: Border.all(width: .5)),
                                height: 30,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await productController.pickThumbnail();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          border: Border(right: BorderSide(width: .5)),
                                          color: Color.fromARGB(86, 220, 218, 218),
                                        ),
                                        child: const Text("Chọn tệp"),
                                      ),
                                    ),
                                    Obx(
                                      () => Container(
                                        height: 40,
                                        padding: const EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        child: productController.thumbnailBytes.value == null
                                            ? const Text("Không có tệp nào được chọn")
                                            : const Text("1 tệp đã được chọn"),
                                      ),
                                    )
                                  ],
                                )),
                            Obx(() => productController.thumbnailBytes.value != null
                                ? Container(
                                    margin: const EdgeInsets.only(top: 7),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Image.memory(  
                                      productController.thumbnailBytes.value!,
                                      height: 100,
                                      width: 100,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          margin: const EdgeInsets.all(5),
                                          height: 100,
                                          width: 100,
                                          color: Colors.grey,
                                          child: const Center(
                                            child: Icon(Icons.error, color: Colors.red),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container()),
                            const SizedBox(height: 10),
                            const Text("Ảnh Sản Phẩm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Container(
                                decoration: BoxDecoration(border: Border.all(width: .5)),
                                height: 30,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await productController.pickImages();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          border: Border(right: BorderSide(width: .5)),
                                          color: Color.fromARGB(86, 220, 218, 218),
                                        ),
                                        child: const Text("Chọn tệp"),
                                      ),
                                    ),
                                    Obx(
                                      () => Container(
                                        height: 40,
                                        padding: const EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        child: productController.uploadedImageBytes.isNotEmpty
                                            ? Text("${productController.uploadedImageBytes.length} tệp nào được chọn")
                                            : const Text("Không có tệp nào được chọn"),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(height: 10),
                            Wrap(
                              children: productController.uploadedImageBytes.map((imageBytes) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 7, bottom: 7),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey,
                                            child: const Center(
                                              child: Icon(Icons.error, color: Colors.red),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                        right: 2,
                                        left: 65,
                                        bottom: 75,
                                        child: IconButton(
                                            color: TColros.purple_line,
                                            onPressed: () {
                                              productController.uploadedImageBytes.remove(imageBytes);
                                            },
                                            icon: const Icon(Icons.remove_circle_outlined))),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            const Text(("Mô Tả"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Container(
                              alignment: Alignment.topLeft,
                              height: 150,
                              child: TextField(
                                maxLines: 6,
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.top,
                                controller: productController.descriptionController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                          
                                  ProductModel newProduct = ProductModel(
                                    KhuyenMai: 1,
                                    id: productController.generateId(),
                                    ten: productController.nameController.text,
                                    moTa: productController.descriptionController.text,
                                    giaTien: int.parse(productController.priceController.text),
                                    hinhAnh: productController.uploadedImages.toList(),
                                    thumbnail: productController.thumbnailName.value,
                                    maDanhMuc: productController.selectedCategory.value,
                                    trangThai: true,
                                    NgayNhap: productController.date,
                                    isPopular: productController.isPopular.value,
                                  );
                        
                                  productController.addProduct(newProduct);
                                  
                               
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: double.minPositive),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 10,
                                  margin: EdgeInsets.only(right: 10.w),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: const Border.fromBorderSide(BorderSide.none),
                                    color: TColros.purple_line,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Thêm sản phẩm',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(Icons.add, size: 20, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  controllerProductSample.addAtribute.value
                      ? Expanded(
                          child: AddAtributeSample(
                          maSanPham: productController.generateId(),
                        ))
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
