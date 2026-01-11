import 'package:partywity/featues/booking/domain/entities/entities.dart';

class CityModel extends CityEntity {
  CityModel({required super.id, required super.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}