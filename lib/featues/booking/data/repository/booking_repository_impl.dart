import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:partywity/featues/booking/data/model/city_model.dart';
import 'package:partywity/featues/booking/domain/entities/entities.dart';
import 'package:partywity/featues/booking/domain/repository/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final Dio _dio;

  BookingRepositoryImpl(this._dio);


@override
Future<List<PackageEntity>> getPackages(String type) async {
  const String endpoint = "/getDataPost/AllPackageTitle";
  final formData = FormData.fromMap({'type': type});

  final response = await _dio.post(endpoint, data: formData);

  
  final Map<String, dynamic> responseBody = response.data is String 
      ? jsonDecode(response.data) 
      : response.data;

  if (responseBody['status'] == true) {
    final List<dynamic> rawData = responseBody['data'];
    

    return rawData.map((json) {
      return PackageEntity(
        category: json['package'] ?? '', 
        items: [json['name'] ?? ''],      
      );
    }).toList();
  } else {
    throw Exception(responseBody['msg'] ?? "No packages found");
  }
}
@override
Future<List<CityEntity>> getCities() async {

    const String endpoint = "/getData/getAreaLead"; 

    
    final response = await _dio.get(endpoint);

   
  final Map<String, dynamic> responseBody = response.data is String 
      ? jsonDecode(response.data) 
      : response.data;

  if (responseBody['status'] == true) {
    final List<dynamic> rawData = responseBody['data'] ?? [];
    
    
    return rawData.map((json) => CityModel.fromJson(json)).toList();
  } else {
    throw Exception(responseBody['msg'] ?? "Failed to fetch cities");
  }
}
@override
Future<List<AreaEntity>> getAreas(String cityId) async {
  final formData = FormData.fromMap({'city_id': cityId});
  final response = await _dio.post("/getDataPost/AreaLead", data: formData);

  final responseBody = response.data is String ? jsonDecode(response.data) : response.data;

  if (responseBody['status'] == true) {
    final List<dynamic> rawData = responseBody['data'];
    return rawData.map((json) {
      return AreaEntity(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        cityName: json['city_name'] ?? '', stateName: '', cityId: '', 
      );
    }).toList();
  }
  return [];
}
}