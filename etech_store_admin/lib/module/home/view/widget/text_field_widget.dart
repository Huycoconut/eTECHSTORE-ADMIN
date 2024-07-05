import 'package:etech_store_admin/utlis/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFiewWidget extends StatelessWidget {
  TextFiewWidget({super.key, required this.color, required this.icon, required this.hinhText, required this.controller});
  Icon icon;
  TextEditingController controller;
  Color color;
  String hinhText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true, // Added this
        contentPadding: const EdgeInsets.all(8),
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: color),
          borderRadius: BorderRadius.circular(2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: color),
          borderRadius: BorderRadius.circular(2),
        ),
        hintText: hinhText,
        hintStyle: TextStyle(color: color),
      ),
    );
  }
}
