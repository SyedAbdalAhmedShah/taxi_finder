import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:taxi_finder/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxi_finder/blocs/bloc/shuttle_city_to_city_bloc.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_shuttle_service_bloc/driver_shuttle_service_bloc.dart';
import 'package:taxi_finder/blocs/driver_map_bloc/driver_taxi_finder_%20bloc%20/driver_taxi_finder_bloc.dart';
import 'package:taxi_finder/blocs/splash_bloc/splash_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/taxi_finder_bloc/taxi_finder_user_bloc.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/dependency_injection/dependency_setup.dart';
import 'package:taxi_finder/firebase_options.dart';
import 'package:taxi_finder/utils/local_notificatioin_service.dart';
import 'package:taxi_finder/views/splash/splash_screen.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  final title = message.notification?.title ?? "";
  final body = message.notification?.body ?? "";
  LocalNotificationService().showNotification(id: 10, title: title, body: body);
}

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await DependencySetup.setupDependencies();
    runApp(const MyApp());
  }, (error, stack) {
    log("error happened in run zoned gurarded $error , $stack",
        name: "RunZoned");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => SplashBloc(),
          ),
          BlocProvider(
            create: (context) => TaxiFinderUserBloc(),
          ),
          BlocProvider(
            create: (context) => DriverTaxiFinderBLoc(),
          ),
          BlocProvider(
            create: (context) => ShuttleFinderBloc(),
          ),
          BlocProvider(
            create: (context) => ShuttleCityToCityBloc(),
          ),
          BlocProvider(
            create: (context) => DriverShuttleServiceBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Taxi Finder',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
            scaffoldBackgroundColor: scaffoldColor,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      );
    });
  }
}
