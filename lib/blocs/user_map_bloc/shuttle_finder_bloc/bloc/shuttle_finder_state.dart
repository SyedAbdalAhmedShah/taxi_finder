part of 'shuttle_finder_bloc.dart';

sealed class ShuttleFinderState {}

final class ShuttleFinderInitial extends ShuttleFinderState {}

final class ShuttleFinderLoadingState extends ShuttleFinderState {}

final class OnRideBookingLoadingState extends ShuttleFinderState {}

final class ShuttleFinderCurrentUserLocationState extends ShuttleFinderState {}

final class ShuttleFinderFailureState extends ShuttleFinderState {
  final String errorMessage;

  ShuttleFinderFailureState({required this.errorMessage});
}

final class RequestNotAcceptedState extends ShuttleFinderState {
  final String errorMessage;

  RequestNotAcceptedState({required this.errorMessage});
}

final class OnShuttleLocationSelectedState extends ShuttleFinderState {
  final CityToCityModel selectedCity;

  OnShuttleLocationSelectedState({required this.selectedCity});
}

final class TooglePickMeUpFromMyLocationState extends ShuttleFinderState {}

final class OnShuttleNearByDriversAddedState extends ShuttleFinderState {}
