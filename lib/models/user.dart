class Profil {
  String name;
  String address;
  String email;
  String phone;

  Profil(
      {required this.name,
      required this.phone,
      required this.address,
      required this.email,});

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'email': email,
        'phone': phone,
      };

  static Profil fromJson(Map<String, dynamic> json) => Profil(
        name: json['name'],
        address: json['address'],
        email: json['email'],
        phone: json['phone'],
      );
}

class PhotoProfil {
   String photo;
   PhotoProfil(
      {
      required this.photo});
  static PhotoProfil fromJson(Map<String, dynamic> json) => PhotoProfil(
        photo: json['photo'],
      );
}