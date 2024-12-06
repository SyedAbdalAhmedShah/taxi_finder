part of 'shuttle_finder_bloc.dart';

sealed class ShuttleFinderState {}

final class ShuttleFinderInitial extends ShuttleFinderState {}

final class ShuttleFinderLoadingState extends ShuttleFinderState {}

final class ShuttleFinderCurrentUserLocationState extends ShuttleFinderState {}

final class ShuttleFinderFailureState extends ShuttleFinderState {}
