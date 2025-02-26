part of 'route_bloc.dart';

sealed class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

class CreateEvent extends RouteEvent {}

class JoinEvent extends RouteEvent {}

class FinishEvent extends RouteEvent {}
