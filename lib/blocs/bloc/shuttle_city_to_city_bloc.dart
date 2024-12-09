import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'shuttle_city_to_city_event.dart';
part 'shuttle_city_to_city_state.dart';

class ShuttleCityToCityBloc extends Bloc<ShuttleCityToCityEvent, ShuttleCityToCityState> {
  ShuttleCityToCityBloc() : super(ShuttleCityToCityInitial()) {
    on<ShuttleCityToCityEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
