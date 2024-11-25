enum RideRequestStatus { pending, accepted, rejected, timeout }

class DriverResponse {
  final RideRequestStatus status;
  final String? acceptedDriverId;

  DriverResponse({required this.status, this.acceptedDriverId});

  static final noDriversAvailable =
      DriverResponse(status: RideRequestStatus.timeout);
}
