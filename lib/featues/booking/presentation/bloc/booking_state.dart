part of 'booking_bloc.dart';

enum BookingStatus { initial, loading, success, failure }

enum GenderCategory { none, male, female }

enum PackageStatus { initial, loading, success, failure }
enum AreaStatus { initial, loading, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final int currentStep;
  final int? totalGuests;
  final int? maleGuests;
  final int? femaleGuests;
  final int? childrenCount;
  final GenderCategory activeGenderCategory; 
  final bool hasKids;
  final DateTime? selectedDate;
  final String? selectedPeriod;
  final String? selectedTime;
  final String? selectedPricingType;
  final String? packageType; 
  final Map<String, List<String>> apiPackages; 
  final PackageStatus packageStatus;
  final List<String> selectedPackages;
  final String? selectedArea;
  final bool isPackageDropdownOpen;
  final bool isCityDropdownOpen;
  final bool isAreaDropdownOpen;
  final List<CityEntity> cities;
  final List<CityEntity> selectedCities; 
  final List<AreaEntity> areas; 
  final List<AreaEntity> selectedAreas; 
  final AreaStatus areaStatus;

  const BookingState({
    this.status = BookingStatus.initial,
    this.currentStep = 0,
    this.totalGuests,
    this.maleGuests,
    this.femaleGuests,
    this.childrenCount,
    this.selectedPricingType,
    this.isPackageDropdownOpen = false,
    this.isCityDropdownOpen = false,
    this.isAreaDropdownOpen = false,
    this.activeGenderCategory = GenderCategory.none, 
    this.hasKids = false,
    this.selectedDate,
    this.selectedPeriod,
    this.selectedTime,
    this.packageType,
    this.apiPackages = const {},
    this.packageStatus = PackageStatus.initial,
    this.selectedPackages = const [],
    this.selectedArea,
    this.cities = const [],
    this.selectedCities = const [],
    this.areas = const [],
    this.selectedAreas = const [],
    this.areaStatus = AreaStatus.initial,
  });

  BookingState copyWith({
    BookingStatus? status,
    int? currentStep,
    int? totalGuests,
    int? maleGuests,
    int? femaleGuests,
    int? childrenCount,
    GenderCategory? activeGenderCategory,
    DateTime? selectedDate,
    String? selectedPeriod,
    String? selectedTime,
    String? selectedPricingType,
    bool? hasKids,
    String? packageType,
    String? selectedPackageName,
    String? selectedArea,
    bool? isPackageDropdownOpen,
    Map<String, List<String>>? apiPackages,
    PackageStatus? packageStatus,
    List<String>? selectedPackages,
    List<CityEntity>? cities,
    bool? isCityDropdownOpen,
    bool? isAreaDropdownOpen,
    List<AreaEntity>? areas,
    List<AreaEntity>? selectedAreas,
    List<CityEntity>? selectedCities,
    AreaStatus? areaStatus,
  }) {
    return BookingState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      totalGuests: totalGuests ?? this.totalGuests,
      maleGuests: maleGuests ?? this.maleGuests,
      femaleGuests: femaleGuests ?? this.femaleGuests,
      childrenCount: childrenCount ?? this.childrenCount,
      selectedPricingType: selectedPricingType ?? this.selectedPricingType,
      activeGenderCategory: activeGenderCategory ?? this.activeGenderCategory,
      isPackageDropdownOpen:
          isPackageDropdownOpen ?? this.isPackageDropdownOpen,
      isCityDropdownOpen: isCityDropdownOpen ?? this.isCityDropdownOpen,
      isAreaDropdownOpen: isAreaDropdownOpen ?? this.isAreaDropdownOpen,
      hasKids: hasKids ?? this.hasKids,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,

      packageType: packageType ?? this.packageType,
      selectedArea: selectedArea ?? this.selectedArea,
      apiPackages: apiPackages ?? this.apiPackages,
      packageStatus: packageStatus ?? this.packageStatus,
      selectedPackages: selectedPackages ?? this.selectedPackages,
      cities: cities ?? this.cities,
      areas: areas ?? this.areas,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      selectedCities: selectedCities ?? this.selectedCities,
      areaStatus: areaStatus ?? this.areaStatus,
    );
  }

  int get remainingGuests {
    return (totalGuests ?? 0) -
        (maleGuests ?? 0) -
        (femaleGuests ?? 0) -
        (childrenCount ?? 0);
  }

  bool get isStage2Valid {
    final bool guestsAllocated = remainingGuests == 0;

    final bool dateSelected = selectedDate != null;

    final bool timeSelected = selectedTime != null && selectedTime!.isNotEmpty;
    final bool pricingSelected = selectedPricingType != null; 

    return guestsAllocated && dateSelected && timeSelected && pricingSelected;
  }

  bool get isFinalStepValid {
    return selectedPackages.isNotEmpty &&
        selectedCities.isNotEmpty &&
        selectedAreas.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    totalGuests,
    maleGuests,
    femaleGuests,
    activeGenderCategory,
    childrenCount,
    hasKids,
    selectedDate,
    selectedPeriod,
    selectedTime,
    selectedPricingType,
    packageType,
    apiPackages,
    packageStatus,
    selectedPackages,
    isPackageDropdownOpen,
    isCityDropdownOpen,
    isAreaDropdownOpen,
    selectedArea,
    cities,
    selectedCities,
    selectedAreas,
    areas,
    areaStatus,
  ];
}
