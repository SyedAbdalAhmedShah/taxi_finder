part of 'driver_shuttle_service_bloc.dart';

@immutable
sealed class DriverShuttleServiceEvent {}

class DriverCurrentLocationEvent extends DriverTaxiFinderEvent {}
