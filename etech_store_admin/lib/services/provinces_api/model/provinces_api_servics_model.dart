import 'dart:convert';

class Ward {
  final String name;
  final int code;

  Ward({required this.name, required this.code});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      name: json['name'],
      code: json['code'],
    );
  }
}

class District {
  final String name;
  final int code;
  final List<Ward> wards;

  District({required this.name, required this.code, required this.wards});

  factory District.fromJson(Map<String, dynamic> json) {
    var wardsList = json['wards'] as List;
    List<Ward> wards = wardsList.map((i) => Ward.fromJson(i)).toList();

    return District(
      name: json['name'],
      code: json['code'],
      wards: wards,
    );
  }
}

class Province {
  final String name;
  final int code;
  final List<District> districts;

  Province({required this.name, required this.code, required this.districts});

  factory Province.fromJson(Map<String, dynamic> json) {
    var districtsList = json['districts'] as List;
    List<District> districts = districtsList.map((i) => District.fromJson(i)).toList();

    return Province(
      name: json['name'],
      code: json['code'],
      districts: districts,
    );
  }
}
