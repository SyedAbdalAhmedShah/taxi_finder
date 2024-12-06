part of 'taxi_finder_user_bloc.dart';

abstract class TaxiFinderUserEvent {}

class FetchCurrentLocation extends TaxiFinderUserEvent {}

class OnDirectionEvent extends TaxiFinderUserEvent {
  final LatLng latLng;

  OnDirectionEvent({required this.latLng});
}

class OnLocationSearchEvent extends TaxiFinderUserEvent {
  final String query;

  OnLocationSearchEvent({required this.query});
}

class NearByDriverAddedEvent extends TaxiFinderUserEvent {
  final List<DriverInfo> nearByDrivers;

  NearByDriverAddedEvent({required this.nearByDrivers});
}

class OnLocationSelectedEvent extends TaxiFinderUserEvent {
  final Prediction prediction;

  OnLocationSelectedEvent({required this.prediction});
}

class OnRequestForRiding extends TaxiFinderUserEvent {}

class RideAcceptedByDriverEvent extends TaxiFinderUserEvent {
  final RideRequest rideRequest;

  RideAcceptedByDriverEvent({required this.rideRequest});
}
