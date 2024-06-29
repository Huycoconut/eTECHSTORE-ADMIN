import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

Widget datePicker(BuildContext context, var selectedDate) {
  return IconButton(
      onPressed: () async {
        final picked = await showMonthPicker(
            context: context,
            initialDate: selectedDate.value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2025));
        if (picked != null && picked != selectedDate.value) {
          selectedDate.value = picked;
        }
      },
      icon: const Icon(Icons.date_range));
}
