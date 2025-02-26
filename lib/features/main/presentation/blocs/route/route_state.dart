part of 'route_bloc.dart';

sealed class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

final class RouteInitial extends RouteState {}

class CreateSuccessState extends RouteState {}

class JoinSuccessState extends RouteState {}

class FinishSuccessState extends RouteState {}
