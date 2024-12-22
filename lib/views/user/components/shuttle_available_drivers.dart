import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/near_by_driver_shuttler.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/models/driver_info.dart';

class ShuttleAvailableDrivers extends StatelessWidget {
  final List<DriverInfo> availableDrivers;
  final CityToCityModel selectedCity;
  final String requestId;
  final String noSeatsWantToBook;
  const ShuttleAvailableDrivers(
      {required this.availableDrivers,
      super.key,
      required this.selectedCity,
      required this.noSeatsWantToBook,
      required this.requestId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: availableDrivers.length,
        padding: EdgeInsets.only(top: 1.h),
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return NearByDriverShuttler(
              noSeatsWantToBook: noSeatsWantToBook,
              requestId: requestId,
              selectedCity: selectedCity,
              driverUid: availableDrivers[index].driverUid ?? "",
              carNumber: availableDrivers[index].carRegNumber ?? "",
              departureTime: availableDrivers[index].deperatureTime ?? "",
              driverName: availableDrivers[index].fullName ?? "",
              driverPicUrl: availableDrivers[index].profileUrl ?? "",
              numberOfSeatAvailable:
                  (availableDrivers[index].availableSeats ?? 0).toString());
        });
  }
}
