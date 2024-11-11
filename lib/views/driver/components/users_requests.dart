
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/constants/app_colors.dart';

class UsersRequestsSection extends StatelessWidget {
  const UsersRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Card(
        color: secondaryColor.withRed(200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: "From  ",
                    children: [
                      TextSpan(
                          text: "dsadsaddsads",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp))
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
                          text: "dsadsaddsads",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp))
                    ],
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text("Accept"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
