import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class StartRouteUsecase {
  final IRouteRepository _routeRepository;

  StartRouteUsecase(this._routeRepository);

  Future<Either<Failure, Unit>> call(String routeId) async {
    return await _routeRepository.startRoute(routeId);
  }
}
