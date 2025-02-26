import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/create_route_usecase.dart'
    show CreateRouteUsecase;
import 'package:f_ecorutas_v1/features/main/domain/usecases/finish_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/join_route_usecase.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final CreateRouteUsecase createRouteUsecase;
  final JoinRouteUsecase joinRouteUsecase;
  final FinishRouteUsecase finishRouteUsecase;
  RouteBloc(
      this.createRouteUsecase, this.joinRouteUsecase, this.finishRouteUsecase)
      : super(RouteInitial()) {
    on<CreateEvent>(_onCreateRoute);
    on<JoinEvent>(_onJoinRoute);
    on<FinishEvent>(_onFinishRoute);
  }

  void _onCreateRoute(CreateEvent event, Emitter<RouteState> emit) async {
    emit(RouteInitial());
    // final result = await createRouteUsecase();
    // result.fold(
    //   (l) => emit(CreateSuccessState()),
    //   (r) => emit(RouteInitial()),
    // );
  }

  void _onJoinRoute(JoinEvent event, Emitter<RouteState> emit) async {
    emit(RouteInitial());
    // final result = await joinRouteUsecase();
    // result.fold(
    //   (l) => emit(JoinSuccessState()),
    //   (r) => emit(RouteInitial()),
    // );
  }

  void _onFinishRoute(FinishEvent event, Emitter<RouteState> emit) async {
    emit(RouteInitial());
    // final result = await finishRouteUsecase();
    // result.fold(
    //   (l) => emit(FinishSuccessState()),
    //   (r) => emit(RouteInitial()),
    // );
  }
}
