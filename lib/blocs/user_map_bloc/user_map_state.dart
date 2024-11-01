part of 'user_map_bloc.dart';

abstract class UserMapState {}

final class UserMapInitial extends UserMapState {}

final class UserMapLoadingState extends UserMapState {}

final class UpdateMapState extends UserMapState {}

final class OnDirectionRequestState extends UserMapState {}
