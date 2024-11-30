import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_bloc.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/models/user_request_model.dart';

class UsersRequestsSection extends StatefulWidget {
  const UsersRequestsSection({super.key});

  @override
  State<UsersRequestsSection> createState() => _UsersRequestsSectionState();
}

class _UsersRequestsSectionState extends State<UsersRequestsSection> {
  late DriverBloc driverBloc;
  @override
  void initState() {
    driverBloc = context.read<DriverBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserRequestModel>>(
        stream: driverBloc.requestbyUserToDriver(),
        builder: (context, snapshot) {
          log('error ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            List<UserRequestModel>? userRequestModel = snapshot.data;
            log("User request ${userRequestModel?.length}");
            if (userRequestModel != null) {
              if (userRequestModel.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) => UserRequestCard(
                          userRequestModel: userRequestModel[index],
                        ));
              }
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class UserRequestCard extends StatelessWidget {
  final UserRequestModel userRequestModel;
  const UserRequestCard({required this.userRequestModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor.withRed(200),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearTimer(
              duration: const Duration(seconds: 10),
              backgroundColor: primaryColor,
              onTimerEnd: () {
                context.read<DriverBloc>().add(OnRequestExpireEvent(
                    docId: userRequestModel.requestId ?? ""));
              },
            ),
            Gap(1.h),
            RichText(
              text: TextSpan(
                  text: "From  ",
                  children: [
                    TextSpan(
                        text: userRequestModel.address,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp))
                  ],
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.0.w, top: 1.h, bottom: 1.h),
              child: ColoredBox(
                color: Colors.red,
                child: SizedBox(
                  width: 0.3.w,
                  height: 8.h, // Adjust height to the desired length
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                  text: "To  ",
                  children: [
                    TextSpan(
                        text: userRequestModel.destination,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp))
                  ],
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<DriverBloc>().add(
                          OnAcceptRide(userRequestModel: userRequestModel));
                    },
                    child: const Text("Accept"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
