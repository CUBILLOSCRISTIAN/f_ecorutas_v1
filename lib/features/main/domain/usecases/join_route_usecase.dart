import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class JoinRouteUsecase {
  final IRouteRepository _repository;

  JoinRouteUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String code, String userName) async {
    return await _repository.joinRoute(code, userName);
  }
}
