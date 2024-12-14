import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_taxi_finder_%20bloc%20/driver_taxi_finder_bloc.dart';
import 'package:taxi_finder/components/primary_button.dart';
import 'package:taxi_finder/constants/app_strings.dart';
import 'package:taxi_finder/views/driver/components/driver_drawer.dart';
import 'package:taxi_finder/views/driver/components/users_requests.dart';
import 'package:taxi_finder/views/driver/taxi_finder_service/driver_map_view.dart';

class TaxiFinderDriverHome extends StatelessWidget {
  const TaxiFinderDriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          welcomeBack,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Stack(
        children: [DriverMapView(), UsersRequestsSection()],
      ),
      bottomSheet: BlocBuilder<DriverTaxiFinderBLoc, DriverTaxiFinderState>(
        builder: (context, state) {
          if (state is RideAcceptedState) {
            return Padding(
                padding: EdgeInsets.all(5.w),
                child: PrimaryButton(
                    text: reachedUserLoc,
                    onPressed: () {
                      context
                          .read<DriverTaxiFinderBLoc>()
                          .add(ReachedOnUserPickupLocation());
                    }));
          } else if (state is ReachedOnUserPickupLocationState) {
            return Padding(
                padding: EdgeInsets.all(5.w),
                child: PrimaryButton(
                    text: rideCompleted,
                    onPressed: () {
                      context
                          .read<DriverTaxiFinderBLoc>()
                          .add(OnRideCompletedEvent());
                    }));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
