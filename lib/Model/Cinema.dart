import 'District.dart';

class Cinema {
  final String id;
  final String name;
  final String districtId;
  final String address;

  Cinema({
    required this.id,
    required this.name,
    required this.districtId,
    required this.address,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'],
      districtId: json['district'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'district': districtId,
      'address': address,
    };
  }
}
