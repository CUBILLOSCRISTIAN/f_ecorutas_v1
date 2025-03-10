part of 'wating_room_bloc.dart';

abstract class WatingRoomState extends Equatable {
  const WatingRoomState();

  @override
  List<Object> get props => [];
}

class WatingRoomInitial extends WatingRoomState {}

class WatingRoomLoading extends WatingRoomState {}

class WatingRoomLoaded extends WatingRoomState {
  final List<String> participants;

  const WatingRoomLoaded(this.participants);

  @override
  List<Object> get props => [participants];
}

class WatingRoomError extends WatingRoomState {
  final String message;

  const WatingRoomError(this.message);

  @override
  List<Object> get props => [message];
}

class RouteStartedState extends WatingRoomState {}

class RouteFinishedState extends WatingRoomState {}
