import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'shuttle_finder_event.dart';
part 'shuttle_finder_state.dart';

class ShuttleFinderBloc extends Bloc<ShuttleFinderEvent, ShuttleFinderState> {
  ShuttleFinderBloc() : super(ShuttleFinderInitial()) {
    on<ShuttleFinderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}