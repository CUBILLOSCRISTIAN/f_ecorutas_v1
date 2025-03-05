import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_guide_repository.dart';

class LoadQuestionsUsecase {
  final IGuideRepository _guideRepository;

  const LoadQuestionsUsecase(this._guideRepository);

  Future<Either<Failure, List<Question>>> call() async {
    return await _guideRepository.loadQuestions();
  }
}
