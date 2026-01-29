import 'package:bloc/bloc.dart';
import 'package:campusbuzz/PersistentView/Bloc/persistent_event.dart';
import 'package:campusbuzz/PersistentView/Bloc/persistent_state.dart';

class PersistentBloc extends Bloc<PersistentEvent, PersistentState>{
  PersistentBloc() : super(PersistentState(0)){
    on<PersistentEvent>((event, emit) {
      emit(PersistentState(event.selectedIndex));

    });
  }

}