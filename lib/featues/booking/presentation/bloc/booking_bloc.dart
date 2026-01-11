
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partywity/featues/booking/data/model/city_model.dart';
import 'package:partywity/featues/booking/domain/entities/entities.dart';
import 'package:partywity/featues/booking/domain/usecases/getarea_usecase.dart';
import 'package:partywity/featues/booking/domain/usecases/getcities_usecase.dart';
import 'package:partywity/featues/booking/domain/usecases/getpackage_usecase.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetPackagesUseCase getPackagesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetAreasUseCase getAreasUseCase;

  BookingBloc({
    required this.getPackagesUseCase,
    required this.getCitiesUseCase,
    required this.getAreasUseCase,
  }) : super(const BookingState()) {
    on<InitializeBooking>((event, emit) {
      emit(const BookingState(status: BookingStatus.initial));
    });

    on<UpdateTotalGuests>((event, emit) {
      emit(state.copyWith(totalGuests: event.count));
    });

    on<UpdateMaleGuests>(
      (event, emit) => emit(state.copyWith(maleGuests: event.count)),
    );

    on<UpdateFemaleGuests>(
      (event, emit) => emit(state.copyWith(femaleGuests: event.count)),
    );

    on<UpdateChildrenCount>(
      (event, emit) => emit(state.copyWith(childrenCount: event.count)),
    );

    on<UpdateSelectedDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
    });

    on<UpdateTimePeriod>((event, emit) {
      emit(state.copyWith(selectedPeriod: event.period, selectedTime: null));
    });

    on<UpdateSelectedTime>((event, emit) {
      emit(state.copyWith(selectedTime: event.time));
    });

    on<SetActiveGenderCategory>((event, emit) {
      emit(state.copyWith(activeGenderCategory: event.category));
    });
    on<ToggleKidsSection>((event, emit) {
      emit(state.copyWith(hasKids: !state.hasKids));
    });
    on<UpdatePricingType>((event, emit) {
      emit(state.copyWith(selectedPricingType: event.type));
    });

    on<UpdatePackageType>((event, emit) {
      emit(state.copyWith(packageType: event.type));
    });

    on<UpdatePackageName>((event, emit) {
      emit(state.copyWith(selectedPackageName: event.name));
    });

    on<FetchCities>((event, emit) async {
      try {
        final List<CityEntity> fetchedCities = await getCitiesUseCase.execute();

        emit(state.copyWith(cities: fetchedCities));

        debugPrint('Fetched Cities Count: ${fetchedCities.length}');
      } catch (e) {
        debugPrint("Error fetching cities: $e");
      }
    });

    on<UpdateArea>((event, emit) {
      emit(state.copyWith(selectedArea: event.area));
    });

    on<TogglePackageDropdown>((event, emit) {
      emit(state.copyWith(isPackageDropdownOpen: !state.isPackageDropdownOpen));
    });

    on<TogglePackageSelection>((event, emit) {
      final List<String> currentSelections = List.from(state.selectedPackages);

      if (state.apiPackages.containsKey(event.packageName)) {
        final List<String> subItems = state.apiPackages[event.packageName]!;

        if (subItems.every((item) => currentSelections.contains(item))) {
          currentSelections.removeWhere((item) => subItems.contains(item));
        } else {
          for (var item in subItems) {
            if (!currentSelections.contains(item)) currentSelections.add(item);
          }
        }
      } else {
        currentSelections.contains(event.packageName)
            ? currentSelections.remove(event.packageName)
            : currentSelections.add(event.packageName);
      }

      emit(state.copyWith(selectedPackages: currentSelections));
    });

    on<FetchPackages>((event, emit) async {
      emit(state.copyWith(packageStatus: PackageStatus.loading));

      try {
        final List<PackageEntity> result = await getPackagesUseCase.execute(
          event.type,
        );

        final Map<String, List<String>> uiMap = {};
        for (var entity in result) {
          final String name = entity.items.first;
          uiMap[name] = [name];
        }

        debugPrint('Fetched Categories (UI Rows): ${uiMap.length}');

        emit(
          state.copyWith(
            packageStatus: PackageStatus.success,
            apiPackages: uiMap,
          ),
        );
      } catch (e) {
        debugPrint("Bloc Error: $e");
        emit(state.copyWith(packageStatus: PackageStatus.failure));
      }
    });

    on<ResetPackages>((event, emit) {
      emit(state.copyWith(selectedPackages: [], isPackageDropdownOpen: false));
    });

    on<ToggleCitySelection>((event, emit) {
      final currentSelected = List<CityModel>.from(state.selectedCities);

      if (currentSelected.any((c) => c.id == event.city.id)) {
        currentSelected.removeWhere((c) => c.id == event.city.id);
      } else {
        currentSelected.add(event.city);
      }

      emit(state.copyWith(selectedCities: currentSelected));

      add(FetchAreasForSelectedCities());
    });

    on<FetchAreasForSelectedCities>((event, emit) async {
      if (state.selectedCities.isEmpty) {
        emit(state.copyWith(areas: []));
        return;
      }

      emit(state.copyWith(areaStatus: AreaStatus.loading));

      try {
        final List<Future<List<AreaEntity>>> futures = state.selectedCities.map(
          (city) {
            return getAreasUseCase.execute(city.id);
          },
        ).toList();

        final results = await Future.wait(futures);
        final allAreas = results.expand((x) => x).toList();

        debugPrint("Total Areas Fetched: ${allAreas.length}");

        emit(
          state.copyWith(
            areas: allAreas,
            areaStatus: AreaStatus.success,
            isAreaDropdownOpen: true,
          ),
        );
      } catch (e) {
        emit(state.copyWith(areaStatus: AreaStatus.failure));
      }
    });

    on<ToggleAreaSelection>((event, emit) {
      final currentSelected = List<AreaEntity>.from(state.selectedAreas);

      if (currentSelected.any((a) => a.id == event.area.id)) {
        currentSelected.removeWhere((a) => a.id == event.area.id);
      } else {
        currentSelected.add(event.area);
      }

      emit(state.copyWith(selectedAreas: currentSelected));
    });

    on<ToggleCityDropdown>(
      (event, emit) => emit(
        state.copyWith(
          isCityDropdownOpen: !state.isCityDropdownOpen,
          isAreaDropdownOpen: false,
          isPackageDropdownOpen: false,
        ),
      ),
    );

    on<ToggleAreaDropdown>(
      (event, emit) => emit(
        state.copyWith(
          isAreaDropdownOpen: !state.isAreaDropdownOpen,
          isCityDropdownOpen: false,
          isPackageDropdownOpen: false,
        ),
      ),
    );
    on<ToggleCityGroupAreas>((event, emit) {
      final currentSelected = List<AreaEntity>.from(state.selectedAreas);
      final cityAreaIds = event.areas.map((a) => a.id).toSet();

      bool areAllSelected = event.areas.every(
        (a) => currentSelected.any((sa) => sa.id == a.id),
      );

      if (areAllSelected) {
        currentSelected.removeWhere((a) => cityAreaIds.contains(a.id));
      } else {
        for (var area in event.areas) {
          if (!currentSelected.any((sa) => sa.id == area.id)) {
            currentSelected.add(area);
          }
        }
      }
      emit(state.copyWith(selectedAreas: currentSelected));
    });

    on<ResetAreas>((event, emit) {
      emit(state.copyWith(selectedAreas: []));
    });

    on<NextStep>((event, emit) {
      if(state.currentStep ==2){
        add((SubmitRegistration()));
        return;
      }

      emit(state.copyWith(currentStep: state.currentStep + 1));
    });

    on<PreviousStep>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<SubmitRegistration>((event, emit) async {
      emit(state.copyWith(status: BookingStatus.loading));
      try {
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(status: BookingStatus.success));
      } catch (e) {
        emit(state.copyWith(status: BookingStatus.failure));
      }
    });
  }
}
