import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/create_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/finish_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/join_route_usecase.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final CreateRouteUsecase createRouteUsecase;
  final JoinRouteUsecase joinRouteUsecase;
  final FinishRouteUsecase finishRouteUsecase;

  RouteBloc({
    required this.createRouteUsecase,
    required this.joinRouteUsecase,
    required this.finishRouteUsecase,
  }) : super(RouteInitial()) {
    on<CreateEvent>(_onCreateRoute);
    on<JoinEvent>(_onJoinRoute);
    on<FinishEvent>(_onFinishRoute);
  }

  void _onCreateRoute(CreateEvent event, Emitter<RouteState> emit) async {
    _emitLoadingState(emit);
    final result = await createRouteUsecase(event.route);
    result.fold(
      (failure) => emit(RouteErrorState(message: failure.message)),
      (success) => emit(OperationSuccessState(
        message: 'Route created successfully',
        code: event.route.code,
      )),
    );
  }

  void _onJoinRoute(JoinEvent event, Emitter<RouteState> emit) async {
    _emitLoadingState(emit);
    final result = await joinRouteUsecase(event.code, event.userName);
    result.fold(
      (failure) => emit(RouteErrorState(message: failure.message)),
      (success) => emit(OperationSuccessState(
        message: 'Joined route successfully',
        code: event.code,
      )),
    );
  }

  void _onFinishRoute(FinishEvent event, Emitter<RouteState> emit) async {
    _emitLoadingState(emit);
    final result =
        await finishRouteUsecase(event.routeId, event.userId, event.positions);
    result.fold(
      (failure) => emit(RouteErrorState(message: failure.message)),
      (success) => emit(OperationSuccessState(
        message: 'Route finished successfully',
        code: event.routeId,
      )),
    );
  }

  void _emitLoadingState(Emitter<RouteState> emit) {
    emit(RouteLoadingState());
  }
}
