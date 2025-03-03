part of 'route_bloc.dart';

sealed class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

class CreateEvent extends RouteEvent {
  final RouteEntity route;

  const CreateEvent({required this.route});

  @override
  List<Object> get props => [route];
}

class JoinEvent extends RouteEvent {
  final String code;
  final String userName;

  const JoinEvent({
    required this.code,
    required this.userName,
  });

  @override
  List<Object> get props => [code, userName];
}

class FinishEvent extends RouteEvent {
  final String routeId;
  final String userId;
  final List<Map<String, dynamic>> positions;

  const FinishEvent({
    required this.routeId,
    required this.userId,
    required this.positions,
  });

  @override
  List<Object> get props => [routeId, userId, positions];
}
