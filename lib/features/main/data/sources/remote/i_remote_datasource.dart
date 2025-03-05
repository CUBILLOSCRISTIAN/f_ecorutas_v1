import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';

abstract interface class IRemoteDatasource {
  Future<Either<Failure, Unit>> joinRoute(String routeId, String userName);

  Future<Either<Failure, Unit>> createRoute(RouteModel model);

  Future<Either<Failure, Unit>> sentPositions(
      String routeId, String userId, List<Map<String, dynamic>> positions);

  Future<Either<Failure, Unit>> startRoute(String routeId);

  Future<Either<Failure, Stream<dynamic>>> getRoomStream(String code);
  Future<Either<Failure, Unit>> sendQuestion(
      String code, Map<String, dynamic> question);
  Future<Either<Failure, Unit>> sendAnswer(
      String code, String question, String answer);
  Future<Either<Failure, Unit>> finishRoute(String routeId);
}
