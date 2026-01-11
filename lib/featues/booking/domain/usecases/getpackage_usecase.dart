import 'package:partywity/featues/booking/domain/entities/entities.dart';
import 'package:partywity/featues/booking/domain/repository/booking_repository.dart';

class GetPackagesUseCase {
  final BookingRepository repository;
  GetPackagesUseCase(this.repository);

  Future<List<PackageEntity>> execute(String type) => repository.getPackages(type);
}