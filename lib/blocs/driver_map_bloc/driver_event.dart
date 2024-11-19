part of 'driver_bloc.dart';

abstract class DriverEvent {}

class DriverCurrentLocationEvent extends DriverEvent {}

class OnRideRequestRecieveEvent extends DriverEvent {}

class OnRequestExpireEvent extends DriverEvent {
  final String docId;

  OnRequestExpireEvent({required this.docId});
}

class OnAcceptRide extends DriverEvent {
  final String docId;

  OnAcceptRide({required this.docId});
}
