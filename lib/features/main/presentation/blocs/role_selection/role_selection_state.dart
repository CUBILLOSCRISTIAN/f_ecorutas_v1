part of 'role_selection_bloc.dart';

sealed class RoleSelectionState extends Equatable {
  const RoleSelectionState();

  @override
  List<Object> get props => [];
}

final class RoleSelectionInitial extends RoleSelectionState {}

final class GuiaSelectedState extends RoleSelectionState {}

final class ParticipantSelectedState extends RoleSelectionState {}
