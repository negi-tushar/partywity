part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}


class InitializeBooking extends BookingEvent {}

class NextStep extends BookingEvent {}

class PreviousStep extends BookingEvent {}


class UpdateTotalGuests extends BookingEvent {
  final int count;
  const UpdateTotalGuests(this.count);
}


class UpdateMaleGuests extends BookingEvent {
  final int count;
  const UpdateMaleGuests(this.count);
}

class UpdateFemaleGuests extends BookingEvent {
  final int count;
  const UpdateFemaleGuests(this.count);
}

class UpdateChildrenCount extends BookingEvent {
  final int count;
  const UpdateChildrenCount(this.count);
}

class SetActiveGenderCategory extends BookingEvent {
  final GenderCategory category;
  const SetActiveGenderCategory(this.category);
}

class ToggleKidsSection extends BookingEvent {
  final bool hasKids;
  const ToggleKidsSection(this.hasKids);
}

class UpdateSelectedDate extends BookingEvent {
  final DateTime date;
  const UpdateSelectedDate(this.date);
}

class UpdateTimePeriod extends BookingEvent {
  final String period; 
  const UpdateTimePeriod(this.period);
}

class UpdateSelectedTime extends BookingEvent {
  final String time;
  const UpdateSelectedTime(this.time);
}

class UpdatePricingType extends BookingEvent {
  final String type; 
  const UpdatePricingType(this.type);
}

class UpdatePackageType extends BookingEvent {
  final String type;
  const UpdatePackageType(this.type);
}

class UpdatePackageName extends BookingEvent {
  final String name;
  const UpdatePackageName(this.name);
}

class UpdateCity extends BookingEvent {
  final String city;
  const UpdateCity(this.city);
}

class TogglePackageSelection extends BookingEvent {
  final String packageName;

  const TogglePackageSelection(this.packageName);

  @override
  List<Object?> get props => [packageName];
}

class UpdateArea extends BookingEvent {
  final String area;
  const UpdateArea(this.area);
}

class TogglePackageDropdown extends BookingEvent {}

class ToggleCitySelection extends BookingEvent {
  final CityModel city;
  const ToggleCitySelection(this.city);
}

class ToggleAreaSelection extends BookingEvent {
  final AreaEntity area;
  const ToggleAreaSelection(this.area);
}

class ToggleCityDropdown extends BookingEvent {}

class ToggleAreaDropdown extends BookingEvent {}

class FetchPackages extends BookingEvent {
  final String type; 
  const FetchPackages(this.type);

  @override
  List<Object?> get props => [type];
}

class ResetPackages extends BookingEvent {
  const ResetPackages();

  @override
  List<Object?> get props => [];
}


class FetchCities extends BookingEvent {}

class SelectCity extends BookingEvent {
  final CityModel city;
  const SelectCity(this.city);
}

class FetchAreasForSelectedCities extends BookingEvent {
  const FetchAreasForSelectedCities();
}


class ToggleCityGroupAreas extends BookingEvent {
  final List<AreaEntity> areas;
  const ToggleCityGroupAreas(this.areas);

  @override
  List<Object?> get props => [areas];
}


class ResetAreas extends BookingEvent {
  const ResetAreas();
}


class SubmitRegistration extends BookingEvent {}
