import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/local/i_local_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';
import 'package:workmanager/workmanager.dart';

class RouteRepositoryImpl implements IRouteRepository {
  final IRemoteDatasource _remoteDatasource;
  final ILocalDatasource _localDatasource;

  const RouteRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, Unit>> createRoute(RouteEntity entity) async {
    try {
      final model = RouteModel.toEntity(entity);
      return await _remoteDatasource.createRoute(model);
    } catch (e) {
      return Left(CreateFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> finishRoute(
    String routeId,
    String userName,
  ) async {
    Workmanager()
        .cancelByUniqueName('track_location_task'); // Detiene el tracking
    List<Map<String, dynamic>> positions =
        _localDatasource.positions.map((e) => e.toJson()).toList();
    print('positions: $positions');
    return await _remoteDatasource.sentPositions(routeId, userName, positions);
  }

  @override
  Future<Either<Failure, Unit>> joinRoute(String code, String userName) async {
    return await _remoteDatasource.joinRoute(code, userName);
  }

  @override
  Future<Either<Failure, Unit>> startRoute(String routeId) async {
    _localDatasource.startTracking();
    return await _remoteDatasource.startRoute(routeId);
  }

  @override
  Future<Either<Failure, Stream>> getRoomStream(String code) async {
    return await _remoteDatasource.getRoomStream(code);
  }

  @override
  Future<Either<Failure, Unit>> sendAnswer(
      String code, String answer, String question) {
    return _remoteDatasource.sendAnswer(code, answer, question);
  }

  @override
  Future<Either<Failure, Unit>> sendQuestion(
      String code, Map<String, dynamic> question) {
    return _remoteDatasource.sendQuestion(code, question);
  }

  @override
  Future<Either<Failure, Unit>> startTranking() async {
    try {
      Workmanager().registerOneOffTask(
        'track_location_task',
        'start_tracking',
        constraints: Constraints(
          networkType: NetworkType.connected, // Solo con internet
          requiresBatteryNotLow: true, // No se ejecuta si la batería está baja
        ),
      );
      return Right(unit);
    } catch (e) {
      return Left(ErrorFailure());
    }
  }
}
