import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/route_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';
import 'package:geolocator/geolocator.dart';

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
        await _firestore.collection('rutas').doc(routeId).update({
          'participants': FieldValue.arrayUnion([
            {'name': userName}
          ])
        });
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
  Future<Either<Failure, Unit>> sentPositions(String routeId, String userId,
      List<Map<String, dynamic>> positions) async {
    try {
      await _firestore.collection('rutas').doc(routeId).update({
        'positions': FieldValue.arrayUnion(positions),
      });
      return Right(unit);
    } catch (e) {
      return Left(FinishFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> startRoute(String routeId) async {
    try {
      await _firestore
          .collection('rutas')
          .doc(routeId)
          .update({'status': 'iniciado'});
      return Right(unit);
    } catch (e) {
      return Left(StartFailure());
    }
  }

  @override
  Future<Either<Failure, Stream>> getRoomStream(String code) async {
    try {
      var result = _firestore.collection('rutas').doc(code).snapshots();
      return Right(result);
    } catch (e) {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sendAnswer(
      String code, Map<int, int> answer) async {
    try {
      final docRef = _firestore.collection('rutas').doc(code);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("No se encontró la ruta");
        }

// Convertir el mapa de respuestas (claves int -> String)
        final Map<String, int> answerWithStringKeys = answer.map(
          (key, value) => MapEntry(key.toString(), value),
        );

        // Actualizar Firestore con el nuevo historial
        transaction.update(docRef, {
          'answers': FieldValue.arrayUnion([answerWithStringKeys])
        });
      });

      return Right(unit);
    } catch (e) {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sendQuestion(
      String code, List<Map<String, dynamic>> question, String place) async {
    try {
      await _firestore.collection('rutas').doc(code).update({
        'pregunta_actual': '',
      });

      await _firestore.collection('rutas').doc(code).update({
        'pregunta_actual': question,
        'historial_preguntas': FieldValue.arrayUnion([
          {
            'lugar': place,
            'pregunta': question,
            'respuestas': [],
            'geolocalizacion': await _getCurrentLocation(),
          }
        ]),
      });

      return Right(unit);
    } catch (e) {
      return Left(ErrorFailure());
    }
  }

  Future<Map<String, dynamic>> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }

  @override
  Future<Either<Failure, Unit>> finishRoute(String routeId) async {
    try {
      await _firestore
          .collection('rutas')
          .doc(routeId)
          .update({'status': 'finalizado'});
      return Right(unit);
    } catch (e) {
      return Left(StartFailure());
    }
  }
}
