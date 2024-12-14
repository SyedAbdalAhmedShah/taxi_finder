part of 'driver_taxi_finder_bloc.dart';

abstract class DriverTaxiFinderState {}

final class DriverInitial extends DriverTaxiFinderState {}

final class DriverMapLoadingState extends DriverTaxiFinderState {}

final class ExpiredRequestState extends DriverTaxiFinderState {}

final class RideAcceptedState extends DriverTaxiFinderState {}

final class ReachedOnUserPickupLocationState extends DriverTaxiFinderState {}

final class CompletedRideState extends DriverTaxiFinderState {}

final class DriverMapFailureState extends DriverTaxiFinderState {}

final class DriverCurrentLocationUpdatedState extends DriverTaxiFinderState {}
