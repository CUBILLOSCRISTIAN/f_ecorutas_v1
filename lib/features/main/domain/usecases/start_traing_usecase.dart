import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class StartTraingUsecase {
  final IRouteRepository _repository;

  StartTraingUsecase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.startTranking();
  }
}
