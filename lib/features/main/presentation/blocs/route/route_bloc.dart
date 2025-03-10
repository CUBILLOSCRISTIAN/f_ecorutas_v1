import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/create_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/join_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/sent_positions_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/start_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/start_traing_usecase.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final CreateRouteUsecase createRouteUsecase;
  final JoinRouteUsecase joinRouteUsecase;
  final SentPositionsUsecase sentPositionsUsecase;
  final StartRouteUsecase startRouteUsecase;
  final StartTraingUsecase startTraingUsecase;

  RouteBloc({
    required this.createRouteUsecase,
    required this.joinRouteUsecase,
    required this.sentPositionsUsecase,
    required this.startRouteUsecase,
    required this.startTraingUsecase,
  }) : super(RouteInitial()) {
    on<CreateEvent>(_onCreateRoute);
    on<JoinEvent>(_onJoinRoute);
    on<FinishEvent>(_onFinishRoute);
    on<StartEvent>(_onStartRoute);
    on<StartTrankingEvent>(_onStarTranking);
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

  void _onStartRoute(StartEvent event, Emitter<RouteState> emit) async {
    _emitLoadingState(emit);
    await startRouteUsecase(event.routeId);
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

    final result = await sentPositionsUsecase(event.routeId, event.userId);
    result.fold(
      (failure) => emit(RouteErrorState(message: failure.message)),
      (success) => emit(RouteInitial()),
    );
    emit(RouteInitial());
  }

  void _emitLoadingState(Emitter<RouteState> emit) {
    emit(RouteLoadingState());
  }

  void _onStarTranking(
      StartTrankingEvent event, Emitter<RouteState> emit) async {
    await startTraingUsecase();
  }
}
