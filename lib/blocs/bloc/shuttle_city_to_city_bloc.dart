import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/models/city_to_city_model.dart';
import 'package:taxi_finder/repositories/shuttle_city_to_city_repo.dart';

part 'shuttle_city_to_city_event.dart';
part 'shuttle_city_to_city_state.dart';

class ShuttleCityToCityBloc
    extends Bloc<ShuttleCityToCityEvent, ShuttleCityToCityState>
    with ShuttleCityToCityRepo {
  ShuttleCityToCityBloc() : super(ShuttleCityToCityInitial()) {
    on<GetAvailableShuttleCities>((event, emit) async {
      try {
        emit(ShuttleCityToCityLoadingState());
        List<CityToCityModel> availableCites = await getAvailableCities();
        log('city to city length ${availableCites.length}');

        emit(ShuttleAvailableCitiesFetchedState(
            availableCities: availableCites));
      } catch (erroor) {
        emit(ShuttleCityToCityFailureState(errorMessage: erroor.toString()));
      }
    });
  }
}
