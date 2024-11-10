import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/components/cache_network_image_view.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';

class DriverDrawer extends StatefulWidget {
  const DriverDrawer({super.key});

  @override
  State<DriverDrawer> createState() => _DriverDrawerState();
}

class _DriverDrawerState extends State<DriverDrawer> {
  late CurrentUserDependency currentUserDependency;

  @override
  void initState() {
    currentUserDependency = locator.get<CurrentUserDependency>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryColor.withBlue(120),
      child: SafeArea(
        child: Column(
          children: [
            Gap(1.h),
            CacheNetworkImageView(
                imageUrl: currentUserDependency.driverInfo.profileUrl ?? ""),
            const Divider(),
            Gap(1.h),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.logout_rounded),
              title: Text("Logout"),
              trailing: Icon(Icons.adaptive.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
