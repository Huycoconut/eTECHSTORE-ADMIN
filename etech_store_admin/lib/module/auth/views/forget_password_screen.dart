import 'package:etech_store_admin/module/auth/controller/forget_password_controller.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:etech_store_admin/utlis/constants/text_strings.dart';
import 'package:etech_store_admin/utlis/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Quên mật khẩu",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 15),
              Text("Nhập email để đổi mật khẩu mới",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 15),
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                    controller: controller.email,
                    validator: TValidator.validateEmail,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: TColros.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: TColros.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: TTexts.nhapEmail,
                      prefixIcon: const Icon(Icons.email),
                    )),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
