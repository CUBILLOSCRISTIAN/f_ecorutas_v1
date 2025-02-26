import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class CreateRouteUsecase {
  final IRouteRepository _repository;

  CreateRouteUsecase(this._repository);

  Future<Either<Failure, Unit>> call(RouteEntity entity) async {
    return await _repository.createRoute(entity);
  }
}
