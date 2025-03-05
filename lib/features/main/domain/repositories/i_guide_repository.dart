import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';

abstract interface class IGuideRepository {
  Future<Either<Failure, List<Question>>> loadQuestions();
  Future<Either<Failure, Unit>> finishRoute(String routeId);
}
