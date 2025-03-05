import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_guide_repository.dart';

class FinishRouteUsecase {
  final IGuideRepository _repository;

  FinishRouteUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String routeId) async {
    return await _repository.finishRoute(routeId);
  }
}
