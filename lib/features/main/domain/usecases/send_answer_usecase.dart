import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class SendAnswerUsecase {
  final IRouteRepository _repository;

  SendAnswerUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String code, Map<int, int> answer) async {
    return await _repository.sendAnswer(code, answer);
  }
}
