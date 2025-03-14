import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/core/services/task_handler.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/local/i_local_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/route.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class RouteRepositoryImpl implements IRouteRepository {
  final IRemoteDatasource _remoteDatasource;
  final ILocalDatasource _localDatasource;

  final List<Map<String, dynamic>> _locations = [];

  RouteRepositoryImpl(this._remoteDatasource, this._localDatasource);

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
    // Detiene el tracking
    // List<Map<String, dynamic>> positions =
    //     _localDatasource.positions.map((e) => e.toJson()).toList();
    // print('positions: $positions');

    await FlutterForegroundTask.stopService();

    print('finishRoute: $routeId, $userName, $_locations');

    return await _remoteDatasource.sentPositions(routeId, userName, _locations);
  }

  @override
  Future<Either<Failure, Unit>> joinRoute(String code, String userName) async {
    return await _remoteDatasource.joinRoute(code, userName);
  }

  @override
  Future<Either<Failure, Unit>> startRoute(String routeId) async {
    // _localDatasource.startTracking();
    return await _remoteDatasource.startRoute(routeId);
  }

  @override
  Future<Either<Failure, Stream>> getRoomStream(String code) async {
    return await _remoteDatasource.getRoomStream(code);
  }

  @override
  Future<Either<Failure, Unit>> sendAnswer(String code, Map<int, int> answer) {
    return _remoteDatasource.sendAnswer(code, answer);
  }

  @override
  Future<Either<Failure, Unit>> sendQuestion(
      String code, List<Question> question) {
    var questionTransform = question.map((e) => e.toJson()).toList();
    return _remoteDatasource.sendQuestion(code, questionTransform);
  }

  @override
  Future<Either<Failure, Unit>> startTranking() async {
    try {
      print('startTranking');
      await FlutterForegroundTask.startService(
        notificationTitle: 'Seguimiento de ubicación',
        notificationText: 'Obteniendo ubicación...',
        callback: startCallback,
      );
      return Right(unit);
    } catch (e) {
      return Left(ErrorFailure());
    }
  }

  @override
  void saveLocation(Map<String, dynamic> location) {
    _locations.add(location);
  }
}
