part of 'shuttle_city_to_city_bloc.dart';

sealed class ShuttleCityToCityState {}

final class ShuttleCityToCityInitial extends ShuttleCityToCityState {}

final class ShuttleCityToCityFailureState extends ShuttleCityToCityState {}

final class ShuttleCityToCityLoadingState extends ShuttleCityToCityState {}

final class ShuttleAvailableCitiesFetchedState extends ShuttleCityToCityState {}
