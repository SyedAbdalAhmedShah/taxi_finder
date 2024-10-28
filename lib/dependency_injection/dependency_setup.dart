import 'package:get_it/get_it.dart';
import 'package:taxi_finder/dependency_injection/current_user.dart';
import 'package:taxi_finder/dependency_injection/shared_prefrences.dart';

final locator = GetIt.instance;

class DependencySetup {
  static setupDependencies() async {
    locator.registerSingleton<CurrentUserDependency>(CurrentUserDependency());
    final sharedPrefDependency =
        locator.registerSingleton<SharedPrefrencesDependency>(
            SharedPrefrencesDependency());
    await sharedPrefDependency.initializeSharedPrefrences();
  }
}
