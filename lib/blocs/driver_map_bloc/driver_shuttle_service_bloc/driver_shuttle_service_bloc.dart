import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_finder/models/user_request_model.dart';
import 'package:taxi_finder/repositories/driver_map_repo.dart';
import 'package:taxi_finder/utils/utils.dart';

part 'driver_shuttle_service_event.dart';
part 'driver_shuttle_service_state.dart';

class DriverShuttleServiceBloc
    extends Bloc<DriverShuttleServiceEvent, DriverShuttleServiceState>
    with DriverMapRepo {
  late GoogleMapController mapController;
  late List<UserRequestModel> userRequest;
  StreamSubscription<Position>? positionStream;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late Position driverCurrentPosition;
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  DriverShuttleServiceBloc() : super(DriverShuttleServiceInitial()) {
    on<DriverCurrentLocationEvent>((event, emit) async {
      emit(DriverShuttleServiceLoadingState());
      try {
        bool isPermisssionGranted = await Utils.isPermissionGranted();
        if (isPermisssionGranted) {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            driverCurrentPosition = await Geolocator.getCurrentPosition();
            await updateDriverLocation(driverCurrentPosition);
            cameraPosition = CameraPosition(
              target: LatLng(driverCurrentPosition.latitude,
                  driverCurrentPosition.longitude),
              zoom: 16.4746,
            );
            mapController
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            positionStream = Utils.getPositionListner();
            emit(ShuttleDriverCurrentLocationState());
          } else {
            add(DriverCurrentLocationEvent());
          }
        } else {
          add(DriverCurrentLocationEvent());
        }
      } catch (e) {
        log('error happened $e');
        emit(DriverShuttleServiceFailureState());
      }
    });
  }
}
