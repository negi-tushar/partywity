
import 'package:partywity/featues/booking/domain/entities/entities.dart';

class AreaModel extends AreaEntity {
  final String stateId; 
  
  AreaModel({
    required super.id,
    required super.name,
    required super.cityId,
    required super.cityName,
    required super.stateName,
    this.stateId = '', 

  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      cityId: json['city_id']?.toString() ?? '',
      cityName: json['city_name'] ?? '',
      stateId: json['state_id']?.toString() ?? '',
      stateName: json['state_name'] ?? '',
    );
  }
}