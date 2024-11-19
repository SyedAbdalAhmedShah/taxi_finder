part of 'driver_bloc.dart';

abstract class DriverState {}

final class DriverInitial extends DriverState {}

final class DriverMapLoadingState extends DriverState {}

final class ExpiredRequestState extends DriverState {}

final class RideAcceptedState extends DriverState {}

final class DriverMapFailureState extends DriverState {}

final class DriverCurrentLocationUpdatedState extends DriverState {}
