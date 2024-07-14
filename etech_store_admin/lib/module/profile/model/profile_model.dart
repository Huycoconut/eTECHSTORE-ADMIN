class ProfileModel {
  String uid;
  String HoTen;
  String Email;
  String Password;
  int SoDienThoai;
  final String HinhDaiDien;
  bool Quyen;
  int TrangThai;
  String DiaChi;
  String token;

  ProfileModel({
    required this.token,
    required this.uid,
    required this.DiaChi,
    required this.Email,
    required this.HinhDaiDien,
    required this.HoTen,
    required this.Password,
    required this.Quyen,
    required this.SoDienThoai,
    required this.TrangThai,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        token: json['token']??'',
        uid: json['uid']??'',
        DiaChi: json['DiaChi']??'',
        Email: json['email']??'',
        HinhDaiDien: json['HinhDaiDien']??'',
        HoTen: json['HoTen']??'',
        Password: json['password']??'',
        Quyen: json['Quyen']??false,
        SoDienThoai: json['SoDienThoai']??'',
        TrangThai: json['TrangThai']??0,
      );

  Map<String, dynamic> toJson() {
    final json = {
      'token': token,
      'uid': uid,
      'DiaChi': DiaChi,
      'email': Email,
      'HinhDaiDien': HinhDaiDien,
      'HoTen': HoTen,
      'password': Password,
      'Quyen': Quyen,
      'SoDienThoai': SoDienThoai,
      'TrangThai': TrangThai,
    };
    return json;
  }
}
