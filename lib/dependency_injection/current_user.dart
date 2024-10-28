import 'package:taxi_finder/models/driver_info.dart';
import 'package:taxi_finder/models/user_model.dart';

class CurrentUserDependency {
  late DriverInfo driverInfo;
  late UserModel userModel;

  setDriver(DriverInfo driverModel) {
    driverInfo = driverModel;
  }

  setUser(UserModel userInfo) {
    userModel = userInfo;
  }
}
