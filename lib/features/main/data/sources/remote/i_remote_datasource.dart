import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';

abstract interface class IRemoteDatasource {
  Future<Either<Failure, Unit>> joinRoute(String routeId, String userName);

  Future<Either<Failure, Unit>> createRoute(RouteModel model);

  Future<Either<Failure, Unit>> finishRoute(
      String routeId, String userId, List<Map<String, dynamic>> positions);
}
