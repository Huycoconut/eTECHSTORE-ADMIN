import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
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
                          const Text(
                            "Bạn có chắc chắn muốn xóa tài khoản này?",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "*Dữ liệu sẽ không thể khôi phục",
                            style: TextStyle(fontSize: 14, color: Color.fromARGB(188, 158, 158, 158)),
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
                                  onPressed: () {},
                                  child: const Text('NO',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                  onPressed: () {},
                                  child: const Text('YES',
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
          ),
        ),
      ),
    );
  }
}
