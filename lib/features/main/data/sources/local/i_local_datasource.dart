import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/question_model.dart';
import 'package:geolocator/geolocator.dart';

abstract interface class ILocalDatasource {
  Future<Either<Failure, List<QuestionModel>>> loadQuestions();
  Future<void> startTracking();
  List<Position> get positions;
}
