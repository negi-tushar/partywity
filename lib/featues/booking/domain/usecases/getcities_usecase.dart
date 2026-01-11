import 'package:partywity/featues/booking/domain/entities/entities.dart';
import 'package:partywity/featues/booking/domain/repository/booking_repository.dart';

class GetCitiesUseCase {
  final BookingRepository repository;
  GetCitiesUseCase(this.repository);

  Future<List<CityEntity>> execute() => repository.getCities();
}