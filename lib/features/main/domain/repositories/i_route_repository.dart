import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';

abstract interface class IRouteRepository {
  Future<Either<Failure, Unit>> joinRoute(String code, String userName);
  Future<Either<Failure, Unit>> createRoute(RouteEntity entity);
  Future<Either<Failure, Unit>> finishRoute(
      String routeId, String userName, List<Map<String, dynamic>> positions);
}
