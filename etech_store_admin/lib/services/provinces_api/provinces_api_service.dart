import 'dart:convert';
import 'package:etech_store_admin/utlis/constants/image_key.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:etech_store_admin/services/provinces_api/model/provinces_api_servics_model.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ApiServices {
  Future<List<Province>> loadProvinces() async {
    String jsonString = await rootBundle.loadString(ImageKey.jsonListProvinces);
    final jsonResponse = json.decode(jsonString);
    var provincesList = jsonResponse['provincesVietNam'] as List;
    List<Province> provinces = provincesList.map((i) => Province.fromJson(i)).toList();

    return provinces;
  }
}
