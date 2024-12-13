import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'driver_shuttle_service_event.dart';
part 'driver_shuttle_service_state.dart';

class DriverShuttleServiceBloc extends Bloc<DriverShuttleServiceEvent, DriverShuttleServiceState> {
  DriverShuttleServiceBloc() : super(DriverShuttleServiceInitial()) {
    on<DriverShuttleServiceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
