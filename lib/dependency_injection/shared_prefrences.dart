import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesDependency {
  late SharedPreferences preferences;

  initializeSharedPrefrences() async {
    preferences = await SharedPreferences.getInstance();
  }
}
