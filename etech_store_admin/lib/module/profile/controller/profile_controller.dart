import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/profile/model/profile_model.dart';
import 'package:etech_store_admin/services/auth_services.dart';
import 'package:etech_store_admin/services/local_storage_service.dart';
import 'package:etech_store_admin/services/provinces_api/model/provinces_api_servics_model.dart';
import 'package:etech_store_admin/utlis/connection/network_manager.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:etech_store_admin/utlis/helpers/popups/full_screen_loader.dart';
import 'package:etech_store_admin/utlis/helpers/popups/loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final NetworkManager network = Get.put(NetworkManager());
  final LocalStorageService localStorageService = LocalStorageService();
  final AuthServices authServices = Get.put(AuthServices());
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController textController = TextEditingController();
  RxList<String> uploadedImageNames = <String>[].obs;
  Rxn<Uint8List?> thumbnailBytes = Rxn<Uint8List>();
  RxString thumbnailName = ''.obs;
  RxList<Uint8List> uploadedImageBytes = <Uint8List>[].obs;
  RxList<String> uploadedImages = <String>[].obs;
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController dressController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();

  TextEditingController editFullNameController = TextEditingController();

  var provinces = <Province>[].obs;
  var selectedProvince = Rxn<Province>();
  var selectedDistrict = Rxn<District>();
  var selectedWard = Rxn<Ward>();
  var districts = <District>[].obs;
  var ward = <Ward>[].obs;
  File? imagefile;
    var searchName = ''.obs;
  var searchEmail = ''.obs;
  var searchPhone = ''.obs;
  List<ProfileModel> allUsers = [];
   var currentPage = 1.obs;
  var itemsPerPage = 10.obs;

  RxString selectedAuthorization = 'Quản trị viên'.obs;
  List<String> authorization = ['Quản trị viên', 'Người dùng'];

  var isTextValid = false.obs;
  RxList<ProfileModel> profiles = <ProfileModel>[].obs;

  void updatePage(int page) {
    currentPage.value = page;
  }

  void clearText() {
    textController.clear();
    isTextValid.value = false;
  }

  void validateText(String text) {
    isTextValid.value = text.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    loadProvinces();
    getUsers();
  }

  Future<void> editNameUser(ProfileModel profile) async {
    editFullNameController = TextEditingController(text: profile.HoTen);
  }

  void resetValues() {
    selectedDistrict.value = null;
    selectedWard.value = null;
    selectedProvince.value = null;
    phoneNumberController.clear();
    textController.clear();
    uploadedImageNames.clear();
    thumbnailBytes.value = null;
    thumbnailName.value = '';
    uploadedImageBytes.clear();
    uploadedImages.clear();
    emailController.clear();
    dressController.clear();
    passWordController.clear();
    fullNameController.clear();
    confirmPassWordController.clear();
  }



  Stream<List<ProfileModel>> getUsers() {
    return firestore.collection('Users').snapshots().map((query) {
      List<ProfileModel> users = query.docs.map((doc) => ProfileModel.fromJson(doc.data())).toList();
      allUsers = users;
      return users;
    });
  }

  Future<void> updateUserStatus(String uid, bool status) async {
    await firestore.collection('Users').doc(uid).update({'TrangThai': status ? 1 : 0});
  }

  //Get Profile
  Stream<List<ProfileModel>> fetchProfilesStream(String userId) {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        fetchProfilesLocally();
        return Stream.value(profiles);
      } else {
        return firestore.collection('Users').where('uid', isEqualTo: userId).snapshots().map((snapshot) {
          final profileList = snapshot.docs.map((doc) {
            return ProfileModel.fromJson(doc.data());
          }).toList();
          localStorageService.saveProfiles(profileList);
          profiles.assignAll(profileList);
          return profileList;
        });
      }
    } catch (e) {
      return TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
    }
  }

  void fetchProfilesLocally() async {
    List<ProfileModel> localProfiles = await localStorageService.getProfiles();
    profiles.assignAll(localProfiles);
  }

  void signOut() {
    final isconnected = network.isConnectedToInternet.value;
    if (!isconnected) {
      return TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
    } else {
      authServices.signOut();
    }
  }

  //Edit Profile
  Future<void> editProfile(int choice, String uid) async {
    try {
      final isconnected = network.isConnectedToInternet.value;
      if (!isconnected) {
        return TLoaders.errorSnackBar(title: TTexts.thongBao, message: "Không có kết nối internet");
      } else {
        final FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;
        QuerySnapshot querySnapshot = await firestore.collection('Users').where('uid', isEqualTo: uid).get();

        if (querySnapshot.docs.isNotEmpty) {
          QueryDocumentSnapshot document = querySnapshot.docs.first;
          String documentId = document.id;

          switch (choice) {
            case 0:
              await firestore.collection('Users').doc(documentId).update({'HoTen': editFullNameController.text});
              break;
            case 1:
              await firestore.collection('Users').doc(documentId).update({'SoDienThoai': int.parse(phoneNumberController.text)});
              break;
            case 2:
              await firestore.collection('Users').doc(documentId).update({'DiaChi': dressController.text});
              break;
          }
          TLoaders.showSuccessPopup(title: "Thông Báo", description: "Sửa Thành Công", onDismissed: () => const Text(""));
        } else {
          TLoaders.showErrorPopup(title: "Thông Báo", description: "Sửa Thất Bại", onDismissed: () => const Text(""));
        }
      }
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông Báo", description: "Lỗi Xảy Ra Trong Quá Trình Lấy Dữ Liệu", onDismissed: () => const Text(""));
    }
  }

// Fetch Image from Gallery
  Future<void> pickThumbnail() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      thumbnailBytes.value = fileBytes;
      thumbnailName.value = '${DateTime.now().millisecondsSinceEpoch}_${result.files.first.name}';
    }
  }

// Fetch Image from Camera
  Future<void> fetchImageCamera() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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

  Future<void> loadProvinces() async {
    try {
      String jsonString = await rootBundle.loadString(ImageKey.jsonListProvinces);

      final jsonResponse = json.decode(jsonString);

      var provincesList = jsonResponse['provincesVietNam'] as List;

      var parsedProvinces = provincesList.map((provinceJson) {
        districts.value = (provinceJson['districts'] as List).map((districtJson) {
          ward.value = (districtJson['wards'] as List).map((wardJson) {
            return Ward(name: wardJson['name'], code: wardJson['code']);
          }).toList();
          return District(name: districtJson['name'], code: districtJson['code'], wards: ward);
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

  Future<bool> checkEmailExists(String email) async {
    final QuerySnapshot result = await firestore.collection('Users').where('email', isEqualTo: email).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }

  bool areAllFieldsEmpty() {
    return phoneNumberController.text.isEmpty ||
        textController.text.isEmpty ||
        emailController.text.isEmpty ||
        dressController.text.isEmpty ||
        passWordController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        thumbnailBytes.value == null ||
        thumbnailName.value.isEmpty ||
        districts.value.isEmpty ||
        provinces.isEmpty ||
        ward.value.isEmpty;
  }

  //create users
  Future<void> createUser() async {
    try {
      // Kiểm tra xem email đã tồn tại hay chưa
      bool isEmailExists = await checkEmailExists(emailController.text);
      if (!isEmailExists) {
        // Kiểm tra xem tất cả các trường khác đã được điền đầy đủ hay chưa
        if (areAllFieldsEmpty()) {
          final storageRef = _storage.ref().child('thumbnails/${thumbnailName.value}');
          UploadTask uploadTask = storageRef.putData(thumbnailBytes.value!);

          await uploadTask.whenComplete(() async {
            thumbnailName.value = await storageRef.getDownloadURL();
          });

          await authServices.createUser(
            emailController.text,
            passWordController.text,
            fullNameController.text,
            int.parse(phoneNumberController.text),
            "${selectedProvince.value?.name} - ${selectedDistrict.value?.name} - ${selectedWard.value?.name} - ${dressController.text}",
            selectedAuthorization.value == 'Quản trị viên' ? true : false,
            thumbnailName.value,
          );
          resetValues();
          TLoaders.successPopup(title: "Thông báo", description: "Thêm thành công");
        } else {
          TLoaders.showErrorPopup(title: "Thông báo", description: "Vui lòng điền đầy đủ thông tin");
        }
      } else {
        TLoaders.showErrorPopup(title: "Thông báo", description: "Email đã tồn tại");
      }
      
    } catch (e) {
      TLoaders.showErrorPopup(title: "Thông báo", description: "Thêm thất bại");
    }
  }

// Fetch Image from Gallery
}
