part of 'driver_shuttle_service_bloc.dart';

sealed class DriverShuttleServiceState {}

final class DriverShuttleServiceInitial extends DriverShuttleServiceState {}

final class DriverShuttleServiceLoadingState
    extends DriverShuttleServiceState {}

final class DriverShuttleServiceFailureState
    extends DriverShuttleServiceState {}
