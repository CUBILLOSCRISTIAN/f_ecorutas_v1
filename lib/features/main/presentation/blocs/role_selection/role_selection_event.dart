part of 'role_selection_bloc.dart';

sealed class RoleSelectionEvent extends Equatable {
  const RoleSelectionEvent();

  @override
  List<Object> get props => [];
}

class SelectGuiaEvent extends RoleSelectionEvent {}

class SelectParticipantEvent extends RoleSelectionEvent {}
