part of 'wating_room_bloc.dart';

abstract class WatingRoomEvent extends Equatable {
  const WatingRoomEvent();

  @override
  List<Object> get props => [];
}

class LoadParticipantsEvent extends WatingRoomEvent {
  final String code;

  const LoadParticipantsEvent(this.code);

  @override
  List<Object> get props => [code];
}

class LoadParticipantsSuccess extends WatingRoomEvent {
  final List<String> participants;

  const LoadParticipantsSuccess(this.participants);

  @override
  List<Object> get props => [participants];
}

class LoadParticipantsError extends WatingRoomEvent {
  final String message;

  const LoadParticipantsError(this.message);

  @override
  List<Object> get props => [message];
}

class InitialRouteEvent extends WatingRoomEvent {
  const InitialRouteEvent();
}
