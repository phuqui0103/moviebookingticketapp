class Food {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  // Chuyển đổi từ JSON (nếu dữ liệu lấy từ API/PocketBase)
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      description: json['description'],
    );
  }

  // Chuyển đổi thành JSON (nếu cần lưu trữ hoặc gửi API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    };
  }
}
