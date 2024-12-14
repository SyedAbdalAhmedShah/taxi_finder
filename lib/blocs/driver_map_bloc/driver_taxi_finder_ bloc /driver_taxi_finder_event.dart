part of 'driver_taxi_finder_bloc.dart';

abstract class DriverTaxiFinderEvent {}

class DriverCurrentLocationEvent extends DriverTaxiFinderEvent {}

class OnRideRequestRecieveEvent extends DriverTaxiFinderEvent {}

class ReachedOnUserPickupLocation extends DriverTaxiFinderEvent {}

class OnRideCompletedEvent extends DriverTaxiFinderEvent {}

class OnRequestExpireEvent extends DriverTaxiFinderEvent {
  final String docId;

  OnRequestExpireEvent({required this.docId});
}

class OnAcceptRide extends DriverTaxiFinderEvent {
  final UserRequestModel userRequestModel;

  OnAcceptRide({required this.userRequestModel});
}
