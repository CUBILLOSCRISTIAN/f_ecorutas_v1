import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class RouteRepositoryImpl implements IRouteRepository {
  final IRemoteDatasource _remoteDatasource;

  const RouteRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, Unit>> createRoute(RouteEntity entity) async {
    try {
      final model = RouteModel.toEntity(entity);
      return await _remoteDatasource.createRoute(model);
    } catch (e) {
      print(e);
      return Left(CreateFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> finishRoute(String routeId, String userName,
      List<Map<String, dynamic>> positions) async {
    return await _remoteDatasource.finishRoute(routeId, userName, positions);
  }

  @override
  Future<Either<Failure, Unit>> joinRoute(String code, String userName) async {
    return await _remoteDatasource.joinRoute(code, userName);
  }
}
