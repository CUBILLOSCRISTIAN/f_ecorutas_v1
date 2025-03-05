import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class SentPositionsUsecase {
  final IRouteRepository _repository;

  const SentPositionsUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String routeId, String userId,
      ) async {
    return await _repository.finishRoute(routeId, userId);
  }
}
