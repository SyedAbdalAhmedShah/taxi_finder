import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_shuttle_service_bloc/driver_shuttle_service_bloc.dart';

import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/models/shuttle_ride_request.dart';

class UserShuttleRequestCard extends StatelessWidget {
  final ShuttleRideRequest shuttleRideRequest;
  const UserShuttleRequestCard({required this.shuttleRideRequest, super.key});

  @override
  Widget build(BuildContext context) {
    final driverShuttleBloc = context.read<DriverShuttleServiceBloc>();
    return BlocBuilder<DriverShuttleServiceBloc, DriverShuttleServiceState>(
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is DriverShuttleRideAcceptLoadingState,
          progressIndicator: CircularProgressIndicator.adaptive(),
          child: Card(
            color: secondaryColor.withRed(200),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearTimer(
                    duration: const Duration(seconds: 30),
                    backgroundColor: primaryColor,
                    onTimerEnd: () {
                      driverShuttleBloc.add(OnExpireShuttleRideRequest(
                          requestId: shuttleRideRequest.requestId ?? ""));
                    },
                  ),
                  Gap(1.h),
                  RichText(
                    text: TextSpan(
                        text: "From  ",
                        children: [
                          TextSpan(
                              text: "Peshawar ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.sp))
                        ],
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 2.0.w, top: 1.h, bottom: 1.h),
                    child: ColoredBox(
                      color: Colors.red,
                      child: SizedBox(
                        width: 0.3.w,
                        height: 5.h, // Adjust height to the desired length
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "To  ",
                            children: [
                              TextSpan(
                                  text: "${shuttleRideRequest.to}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.sp))
                            ],
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.sp)),
                      ),
                      Row(
                        children: [
                          Text(
                            "Fare: ",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text("R${shuttleRideRequest.fare}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Away ",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text("${shuttleRideRequest.totalDistanceToUser}"),
                        ],
                      ),
                    ],
                  ),
                  Gap(1.h),
                  Visibility(
                      visible: shuttleRideRequest.pickUpFromMyLocation ?? false,
                      child: Text('Pick from user location')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            driverShuttleBloc.add(OnShuttleRideAcceptEvent(
                                requestId: shuttleRideRequest.requestId ?? ""));
                          },
                          child: const Text("Accept"))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
