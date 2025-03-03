
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';

class FirebaseDataSource implements IRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, Unit>> joinRoute(
      String routeId, String userName) async {
    try {
      // Verificar si la ruta existe
      final snapshot = await _firestore.collection('rutas').doc(routeId).get();

      if (snapshot.exists) {
        // Obtener los datos del usuario actual

        await _firestore
            .collection('rutas')
            .doc(routeId)
            .set({'participantes': userName}, SetOptions(merge: true));
        return Right(unit);
      }
      return Left(JoinFailure());
    } catch (e) {
      return Left(JoinFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createRoute(RouteModel model) async {
    try {
      await _firestore.collection('rutas').doc(model.code).set(model.toJson());

      return Right(unit);
    } catch (e) {
      return Left(CreateFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> finishRoute(String routeId, String userId,
      List<Map<String, dynamic>> positions) async {
    try {
      await _firestore.collection('rutas').doc(routeId).update({
        'participantes.$userId.posiciones': positions,
      });
      return Right(unit);
    } catch (e) {
      return Left(FinishFailure());
    }
  }
}
