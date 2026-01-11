import 'package:partywity/featues/booking/domain/entities/entities.dart';

class PackageModel extends PackageEntity {
  final String id;
  final String packageName;
  final String type; 

  PackageModel({
    required this.id,
    required this.packageName,
    required this.type, required super.category, required super.items,
  }) ;

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id']?.toString() ?? '',
      packageName: json['name'] ?? '',
      type: json['package'] ?? '', category: '', items: [], 
    );
  }
}