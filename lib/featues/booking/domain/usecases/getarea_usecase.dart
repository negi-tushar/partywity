import 'package:partywity/featues/booking/domain/entities/entities.dart';
import 'package:partywity/featues/booking/domain/repository/booking_repository.dart';

class GetAreasUseCase {
  final BookingRepository repository;
  GetAreasUseCase(this.repository);

  Future<List<AreaEntity>> execute(String cityId) => repository.getAreas(cityId);
}