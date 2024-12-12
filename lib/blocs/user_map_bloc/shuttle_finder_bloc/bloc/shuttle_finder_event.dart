part of 'shuttle_finder_bloc.dart';

sealed class ShuttleFinderEvent {}

final class GetUserCurrentLocation extends ShuttleFinderEvent {}

final class OnShuttleSelectLocation extends ShuttleFinderEvent {
  final CityToCityModel selectedCity;

  OnShuttleSelectLocation({required this.selectedCity});
}

final class PickMeUpFromMyLocationByUser extends ShuttleFinderEvent {}

final class NotAcceptedBooking extends ShuttleFinderEvent {}

final class OnBookShuttleRide extends ShuttleFinderEvent {
  final CityToCityModel selectedCity;
  final String numOfSeats;
  OnBookShuttleRide({required this.selectedCity, required this.numOfSeats});
}

final class OnNearByShuttleDriversAddedEvent extends ShuttleFinderEvent {
  final List<DriverInfo> availableDrivers;

  OnNearByShuttleDriversAddedEvent({required this.availableDrivers});
}
