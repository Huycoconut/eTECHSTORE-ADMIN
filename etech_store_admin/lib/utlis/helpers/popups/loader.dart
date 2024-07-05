import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';

class TLoaders {
  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToas({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: TColros.orange_light),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: TColros.green_light,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  static Widget successPopup({
    required String title,
    required String description,
    VoidCallback? onDismissed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                width: MediaQuery.of(Get.context!).size.width / 4.5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: Material(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(100.0)),
                          ),
                          child: Lottie.asset(
                            ImageKey.successAnimation,
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 17, color: Color.fromARGB(188, 158, 158, 158)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        //Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 40),
                                  backgroundColor: Colors.blueAccent,
                                  shadowColor: const Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (onDismissed != null) {
                                    onDismissed();
                                  }
                                  Navigator.of(Get.context!).pop();
                                },
                                child: const Text('Đóng',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showSuccessPopup({required String title, required String description, VoidCallback? onDismissed}) {
    showDialog(
      context: Get.context!,
      builder: (context) => successPopup(title: title, description: description, onDismissed: onDismissed),
    );
  }

  static showErrorPopup({required String title, required String description, VoidCallback? onDismissed}) {
    showDialog(
      context: Get.context!,
      builder: (context) => _showErrorPopup(title: title, description: description, onDismissed: onDismissed),
    );
  }

  static showConfirmPopup({required String title, required String description, VoidCallback? onDismissed, VoidCallback? conFirm}) {
    showDialog(
      context: Get.context!,
      builder: (context) => _showComfirmPopup(title: title, description: description, onDismissed: onDismissed, conFirm: conFirm),
    );
  }

  static _showComfirmPopup({required String title, required String description, VoidCallback? onDismissed, VoidCallback? conFirm}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            width: MediaQuery.of(Get.context!).size.width / 4.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Material(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      child: const Icon(Icons.error_outline, color: Colors.red, size: 80.0),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Color.fromARGB(188, 158, 158, 158)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              backgroundColor: const Color.fromARGB(255, 197, 205, 220),
                              shadowColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (onDismissed != null) {
                                onDismissed();
                              }
                              Navigator.of(Get.context!).pop();
                            },
                            child: const Text('Đóng', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              backgroundColor: TColros.purple_line,
                              shadowColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (conFirm != null) {
                                conFirm();
                              }
                              Navigator.of(Get.context!).pop();
                            },
                            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static _showErrorPopup({
    required String title,
    required String description,
    VoidCallback? onDismissed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            width: MediaQuery.of(Get.context!).size.width / 4.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Material(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      child: const Icon(Icons.error_outline, color: Colors.red, size: 80.0),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Color.fromARGB(188, 158, 158, 158)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    //Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              backgroundColor: Colors.blueAccent,
                              shadowColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (onDismissed != null) {
                                onDismissed();
                              }
                              Navigator.of(Get.context!).pop();
                            },
                            child: const Text('Đóng',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(
        Icons.warning,
        color: Colors.white,
      ),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.warning, color: Colors.yellowAccent),
    );
  }
}
