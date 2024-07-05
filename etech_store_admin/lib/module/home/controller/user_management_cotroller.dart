import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:etech_store_admin/module/product/model/product_model.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:etech_store_admin/services/auth_services.dart';
import 'package:etech_store_admin/services/local_storage_service.dart';
import 'package:etech_store_admin/services/provinces_api/model/provinces_api_servics_model.dart';
import 'package:etech_store_admin/utlis/connection/network_manager.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserManagementController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final NetworkManager network = Get.put(NetworkManager());
  final LocalStorageService localStorageService = LocalStorageService();
  final AuthServices authServices = Get.put(AuthServices());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dressController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  var provinces = <Province>[].obs;
  var selectedProvince = Rxn<Province>();
  var selectedDistrict = Rxn<District>();
  var selectedWard = Rxn<Ward>();
  File? imagefile;
  RxString imageUrl = ''.obs;

  RxString selectedAuthorization = 'Quản trị viên'.obs;
  List<String> authorization = ['Quản trị viên', 'Người dùng'];

  @override
  void onInit() {
    super.onInit();
    loadProvinces();
  }

  var isTextValid = false.obs;
  RxList<ProfileModel> profiles = <ProfileModel>[].obs;

  void clearText() {
    textController.clear();
    isTextValid.value = false;
  }

  void validateText(String text) {
    isTextValid.value = text.isNotEmpty;
  }

  Future<void> loadProvinces() async {
    try {
      String jsonString = await rootBundle.loadString(ImageKey.jsonListProvinces);

      final jsonResponse = json.decode(jsonString);

      var provincesList = jsonResponse['provincesVietNam'] as List;

      var parsedProvinces = provincesList.map((provinceJson) {
        var districts = (provinceJson['districts'] as List).map((districtJson) {
          var wards = (districtJson['wards'] as List).map((wardJson) {
            return Ward(name: wardJson['name'], code: wardJson['code']);
          }).toList();
          return District(name: districtJson['name'], code: districtJson['code'], wards: wards);
        }).toList();
        return Province(name: provinceJson['name'], code: provinceJson['code'], districts: districts);
      }).toList();

      provinces.value = parsedProvinces;
    } catch (e) {
      print('Lỗi khi tải dữ liệu JSON: $e');
    }
  }

  void selectProvince(Province? province) {
    selectedProvince.value = province;
    selectedDistrict.value = null;
    selectedWard.value = null;
  }

  void selectDistrict(District? district) {
    selectedDistrict.value = district;
    selectedWard.value = null;
  }

  void selectWard(Ward? ward) {
    selectedWard.value = ward;
  }

  //create users
  Future<void> createUser() async {
    await authServices.createUser(
        emailController.text,
        passWordController.text,
        fullNameController.text,
        int.parse(phoneNumberController.text),
        "${selectedProvince.value?.name} - ${selectedDistrict.value?.name} - ${selectedWard.value?.name} - ${dressController.text}",
        selectedAuthorization.value == 'Quản trị viên' ? true : false,
        imagefile.toString());
  }

// Fetch Image from Gallery

// Fetch Image from Camera
  Future<void> fetchImageCamera() async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot document = querySnapshot.docs.first;
      String documentId = document.id;
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

      if (file == null) return;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload = referenceDirImages.child('$uniqueFileName.jpg');

      try {
        await referenceImageToUpload.putFile(File(file.path));
        String imageUrl = await referenceImageToUpload.getDownloadURL();
        await firestore.collection('Users').doc(documentId).update({'HinhDaiDien': imageUrl});
      } catch (error) {
        TLoaders.errorSnackBar(title: 'Thông báo', message: 'Sửa thất bại.');
      }
    }
  }
}
