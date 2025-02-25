import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';

abstract interface class ISingleRemote<T, ParamsGet> {
  /// Obtiene una entidad de tipo [T] basada en los parámetros proporcionados.
  ///
  /// [params] son los parámetros utilizados para obtener la entidad.
  /// Retorna un `Future` que contiene un `T`, donde `T` la entidad obtenida.
  Future<Either<Failure, T>> fetchData(ParamsGet params);
}
