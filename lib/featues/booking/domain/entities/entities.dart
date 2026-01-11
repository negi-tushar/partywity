class PackageEntity {
  final String category;
  final List<String> items;

  PackageEntity({
    required this.category, 
    required this.items,
  });
}

class CityEntity {
  final String id;
  final String name;
  CityEntity({required this.id, required this.name});
}

class AreaEntity {
  final String id;
  final String name;
  final String cityId;
  final String cityName;
  final String stateName;
  AreaEntity({required this.id, required this.stateName,required this.name, required this.cityId, required this.cityName});
}