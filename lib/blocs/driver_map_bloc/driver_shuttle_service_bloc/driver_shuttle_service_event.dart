part of 'driver_shuttle_service_bloc.dart';

sealed class DriverShuttleServiceEvent {}

class DriverCurrentLocationEvent extends DriverShuttleServiceEvent {}

class OnExpireShuttleRideRequest extends DriverShuttleServiceEvent {
  final String requestId;

  OnExpireShuttleRideRequest({required this.requestId});
}
