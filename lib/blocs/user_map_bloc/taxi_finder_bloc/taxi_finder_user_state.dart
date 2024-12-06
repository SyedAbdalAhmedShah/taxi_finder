part of 'user_map_bloc.dart';

abstract class TaxiFinderUserState {}

class OnRidingRequestLoadingState extends TaxiFinderUserState {}

class OnRidingRequestSendState extends TaxiFinderUserState {}

class OnRideRequestAcceptState extends TaxiFinderUserState {
  final DriverInfo driverInfo;

  OnRideRequestAcceptState({required this.driverInfo});
}

final class UserMapInitial extends TaxiFinderUserState {}

final class UserMapLoadingState extends TaxiFinderUserState {}

final class UserMapFailureState extends TaxiFinderUserState {
  final String errorMessage;

  UserMapFailureState({required this.errorMessage});
}

final class UpdateMapState extends TaxiFinderUserState {}

final class OnDirectionRequestState extends TaxiFinderUserState {
  final String totalLocationDistance;
  final String totalFare;
  final String totalSeatBookController;

  OnDirectionRequestState(
      {required this.totalLocationDistance,
      required this.totalFare,
      required this.totalSeatBookController});
}

final class OnLocationSearchState extends TaxiFinderUserState {}

class OnNearByDriverAdded extends TaxiFinderUserState {}
