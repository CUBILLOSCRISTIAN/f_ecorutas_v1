import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class SendQuestionUsecase {
  final IRouteRepository _repository;

  SendQuestionUsecase(this._repository);

  Future<Either<Failure, Unit>> call(
      String code, List<Question> questions, String place) async {
    return await _repository.sendQuestion(code, questions, place);
  }
}
