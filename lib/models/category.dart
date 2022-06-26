class Category {
  String name;
  String picture;
  Category({
    required this.name,
    required this.picture,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'picture': picture,
      };

  static Category fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
        picture: json['picture'],
      );
}
