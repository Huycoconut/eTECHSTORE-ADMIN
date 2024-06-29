import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etech_store_admin/module/preview/models/product_model.dart';
import 'package:etech_store_admin/module/preview/models/user_model.dart';
import 'package:etech_store_admin/module/wishlist/models/wishlist_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  static WishlistController get instance => Get.find();

  final db = FirebaseFirestore.instance;
  final adminID = FirebaseAuth.instance.currentUser!.uid;
  RxList<WishlistModel> listWishlist = <WishlistModel>[].obs;
  RxList<UserModel> listUser = <UserModel>[].obs;
  RxList<ProductModel> listProduct = <ProductModel>[].obs;
  RxList<ProductModel> listProductinWish = <ProductModel>[].obs;
  RxString userIDSelected = ''.obs;
  @override
  void onInit() {
    fetchWishlist();
    super.onInit();
  }

  Future<void> fetchWishlist() async {
    db.collection('YeuThich').snapshots().listen((cats) {
      listWishlist.clear();
      cats.docs.forEach((cat) {
        listWishlist.add(WishlistModel.fromSnapshot(cat));
      });
    });
    db.collection('Users').snapshots().listen((users) {
      listUser.clear();
      users.docs.forEach((user) {
        listUser.add(UserModel.fromSnapshot(user));
      });
    });
    db.collection('SanPham').snapshots().listen((users) {
      listProduct.clear();
      users.docs.forEach((user) {
        listProduct.add(ProductModel.fromSnapshot(user));
      });
    });
  }

  String getUserName(String userID) {
    String userName = '';
    for (var user in listUser) {
      if (user.uid == userID) {
        userName = user.HoTen;
      }
    }
    return userName;
  }

  int getUserPhone(String userID) {
    int userPhone = 0;
    for (var user in listUser) {
      if (user.uid == userID) {
        userPhone = user.SoDienThoai;
      }
    }
    return userPhone;
  }

  String getProductName(String productID) {
    String productName = '';
    for (var product in listProduct) {
      if (product.id == productID) {
        if (product.Ten.length > 40) {
          productName = '${product.Ten.substring(0, 40)}...';
        } else {
          productName = product.Ten;
        }
      }
    }
    return productName;
  }

  List<ProductModel> getProductList(String userID) {
    userIDSelected = userID.obs;
    listProductinWish.clear();
    List<dynamic> products = [];
    for (var wish in listWishlist) {
      if (wish.MaKhachHang == userID) {
        products = wish.DSSanPham;
      }
    }
    for (var productID in products) {
      for (var product in listProduct) {
        if (product.id == productID) {
          listProductinWish.add(product);
        }
      }
    }
    return listProductinWish;
  }

  Future<void> removeProductinWishlist(String productID, String userID) async {
    List<dynamic> listProductUpdate = [];
    for (var wish in listWishlist) {
      if (wish.MaKhachHang == userID) {
        listProductUpdate = wish.DSSanPham;
      }
    }
    listProductUpdate.removeWhere((wish) => wish == productID);
    await db.collection('YeuThich').doc(userID).get().then((doc) {
      doc.reference.update({'DSSanPham': listProductUpdate});
    });
  }
}
