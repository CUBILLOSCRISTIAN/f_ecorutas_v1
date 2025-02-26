import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'role_selection_event.dart';
part 'role_selection_state.dart';

class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  RoleSelectionBloc() : super(RoleSelectionInitial()) {
    on<SelectGuiaEvent>(_onSelectGuiaEvent);
    on<SelectParticipantEvent>(_onSelectParticipanteEvent);
  }

  void _onSelectGuiaEvent(
      SelectGuiaEvent event, Emitter<RoleSelectionState> emit) {
    emit(GuiaSelectedState());
  }

  void _onSelectParticipanteEvent(
      SelectParticipantEvent event, Emitter<RoleSelectionState> emit) {
    emit(ParticipantSelectedState());
  }
}
