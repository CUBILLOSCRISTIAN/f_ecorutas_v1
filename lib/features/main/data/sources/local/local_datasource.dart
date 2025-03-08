import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/question_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/local/i_local_datasource.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class LocalDatasource implements ILocalDatasource {
  final List<Position> _positions = [];
  Timer? _trackingTimer;

  @override
  List<Position> get positions => _positions;

  @override
  Future<Either<Failure, List<QuestionModel>>> loadQuestions() async {
    try {
      final String response =
          await rootBundle.loadString('assets/questions/questions_test.json');
      final List<dynamic> data = json.decode(response);

      final questions = data.map((e) => QuestionModel.fromJson(e)).toList();
      return Right(questions);
    } catch (e) {
      return Left(ErrorFailure());
    }
  }

  @override
  Future<void> startTracking() async {
    const duration = Duration(seconds: 15);

    _trackingTimer = Timer.periodic(duration, (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
            locationSettings:
                LocationSettings(accuracy: LocationAccuracy.high));

        _positions.add(position);
        print('Nueva posición: ${position}');
      } catch (e) {
        print('Error obteniendo ubicación: $e');
      }
    });
  }

  @override
  void stopTracking() {
    _trackingTimer?.cancel();
    print('Seguimiento de ubicación detenido');
  }
}
