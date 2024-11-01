part of 'user_map_bloc.dart';

abstract class UserMapEvent {}

class FetchCurrentLocation extends UserMapEvent {}

class OnDirectionEvent extends UserMapEvent {
  final LatLng latLng;

  OnDirectionEvent({required this.latLng});
}
