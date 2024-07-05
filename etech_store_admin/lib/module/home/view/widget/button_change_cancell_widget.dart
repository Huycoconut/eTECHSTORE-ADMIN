import 'package:etech_store_admin/module/home/controller/user_management_cotroller.dart';
import 'package:etech_store_admin/services/provinces_api/model/provinces_api_servics_model.dart';
import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ButtonChangeWidget extends StatelessWidget {
  ButtonChangeWidget(
      {super.key, required this.width, required this.text, required this.colorText, required this.colorBackgound, required this.onTap});
  String text;
  double width;
  Color colorText;
  Color colorBackgound;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / width,
        height: 30,
        decoration: BoxDecoration(
          color: colorBackgound,
          border: const Border.fromBorderSide(BorderSide.none),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: colorText),
          ),
        ),
      ),
    );
  }
}
