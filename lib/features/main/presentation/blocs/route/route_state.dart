part of 'route_bloc.dart';

sealed class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

final class RouteInitial extends RouteState {}

final class RouteLoadingState extends RouteState {}

final class OperationSuccessState extends RouteState {
  final String message;
  final String code;

  const OperationSuccessState({required this.message, required this.code});

  @override
  List<Object> get props => [message];
}

final class RouteErrorState extends RouteState {
  final String message;

  const RouteErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
