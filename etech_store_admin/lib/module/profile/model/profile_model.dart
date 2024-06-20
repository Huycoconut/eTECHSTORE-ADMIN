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

  ProfileModel({
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

  factory ProfileModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProfileModel(
      uid: documentId,
      HoTen: data['HoTen'] ?? '',
      Email: data['email'] ?? '',
      Password: data['Password'] ?? '',
      SoDienThoai: data['SoDienThoai'] ?? 0,
      HinhDaiDien: data['HinhDaiDien'] ?? '',
      Quyen: data['Quyen'] ?? false,
      TrangThai: data['TrangThai'] ?? 0,
      DiaChi: data['DiaChi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
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
