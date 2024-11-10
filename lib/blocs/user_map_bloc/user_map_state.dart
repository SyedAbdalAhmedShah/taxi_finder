part of 'user_map_bloc.dart';

abstract class UserMapState {}

class OnRidingRequestLoadingState extends UserMapState {}

final class UserMapInitial extends UserMapState {}

final class UserMapLoadingState extends UserMapState {}

final class UserMapFailureState extends UserMapState {
  final String errorMessage;

  UserMapFailureState({required this.errorMessage});
}

final class UpdateMapState extends UserMapState {}

final class OnDirectionRequestState extends UserMapState {}

final class OnLocationSearchState extends UserMapState {}

class OnNearByDriverAdded extends UserMapState {}
