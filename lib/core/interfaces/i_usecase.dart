import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';

/// Interfaz de caso de uso
///
/// Se define el metodo [call] que se debe implementar en los casos de uso
///
/// Se define el tipo de dato [T] y [Params]
///
abstract interface class IUsecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}
