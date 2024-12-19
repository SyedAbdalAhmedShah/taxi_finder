import 'package:flutter/material.dart';
import 'package:taxi_finder/components/near_by_driver_shuttler.dart';
import 'package:taxi_finder/models/driver_info.dart';

class ShuttleAvailableDrivers extends StatelessWidget {
  final List<DriverInfo> availableDrivers;
  const ShuttleAvailableDrivers({required this.availableDrivers, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      availableDrivers.length,
      (index) => NearByDriverShuttler(
          carNumber: availableDrivers[index].carRegNumber ?? "",
          departureTime: availableDrivers[index].deperatureTime ?? "",
          driverName: availableDrivers[index].fullName ?? "",
          driverPicUrl: availableDrivers[index].profileUrl ?? "",
          numberOfSeatAvailable:
              availableDrivers[index].numberOfSeats.toString()),
    ));
  }
}
