part of 'shuttle_finder_bloc.dart';

sealed class ShuttleFinderEvent {}

final class GetUserCurrentLocation extends ShuttleFinderEvent {}

final class OnShuttleSelectLocation extends ShuttleFinderEvent {
  final CityToCityModel selectedCity;

  OnShuttleSelectLocation({required this.selectedCity});
}

final class PickMeUpFromMyLocationByUser extends ShuttleFinderEvent {
  final String pickUpType;

  PickMeUpFromMyLocationByUser({required this.pickUpType});
}

final class NotAcceptedBooking extends ShuttleFinderEvent {}

final class OnSendShuttleRideRequestToSpecificDriver
    extends ShuttleFinderEvent {
  final CityToCityModel selectedCity;
  final String requestId;
  final String noOfSeats;
  final String driverId;

  OnSendShuttleRideRequestToSpecificDriver(
      {required this.requestId,
      required this.noOfSeats,
      required this.selectedCity,
      required this.driverId});
}

final class OnRideCancelEvent extends ShuttleFinderEvent {
  final String requestId;

  OnRideCancelEvent({required this.requestId});
}

final class OnRequestShuttleRide extends ShuttleFinderEvent {
  final CityToCityModel selectedCity;
  final String numOfSeats;
  OnRequestShuttleRide({required this.selectedCity, required this.numOfSeats});
}

final class OnNearByShuttleDriversAddedEvent extends ShuttleFinderEvent {
  final List<DriverInfo> availableDrivers;

  OnNearByShuttleDriversAddedEvent({required this.availableDrivers});
}
