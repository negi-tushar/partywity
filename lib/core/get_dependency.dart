import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:partywity/core/dio.dart';
import 'package:partywity/featues/booking/data/repository/booking_repository_impl.dart';
import 'package:partywity/featues/booking/domain/repository/booking_repository.dart';
import 'package:partywity/featues/booking/domain/usecases/getarea_usecase.dart';
import 'package:partywity/featues/booking/domain/usecases/getcities_usecase.dart';
import 'package:partywity/featues/booking/domain/usecases/getpackage_usecase.dart';
import 'package:partywity/featues/booking/presentation/bloc/booking_bloc.dart';

final getIt = GetIt.instance;

void initDependency() {
  //  Dio Client
  getIt.registerLazySingleton<Dio>(() => DioClient.getInstance());
  //  Repository
  getIt.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(getIt()));

  //  UseCases
  getIt.registerLazySingleton(() => GetAreasUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCitiesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPackagesUseCase(getIt()));

  // Bloc (Passing UseCases from getit into constructor)
  getIt.registerFactory(() => BookingBloc(
    getAreasUseCase: getIt(),
    getCitiesUseCase: getIt(),
    getPackagesUseCase: getIt(),
  ));
}