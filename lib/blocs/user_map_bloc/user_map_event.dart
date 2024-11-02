part of 'user_map_bloc.dart';

abstract class UserMapEvent {}

class FetchCurrentLocation extends UserMapEvent {}

class OnDirectionEvent extends UserMapEvent {
  final LatLng latLng;

  OnDirectionEvent({required this.latLng});
}

class OnLocationSearchEvent extends UserMapEvent {
  final String query;

  OnLocationSearchEvent({required this.query});
}

class OnLocationSelectedEvent extends UserMapEvent {
  final Prediction prediction;

  OnLocationSelectedEvent({required this.prediction});
}
