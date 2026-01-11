import 'package:partywity/featues/booking/domain/entities/entities.dart';

abstract class BookingRepository {
  Future<List<PackageEntity>> getPackages(String type);
  Future<List<CityEntity>> getCities();
  Future<List<AreaEntity>> getAreas(String cityId);
}