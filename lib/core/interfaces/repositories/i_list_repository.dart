import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';

/// Interfaz base para un repositorio genérico.
///
/// [T] es el tipo de entidad que maneja el repositorio.
/// [ParamsGetList] es el tipo de parámetro utilizado para obtener una lista de entidades.
abstract interface class IListRepository<T, ParamsGetList> {
  /// Obtiene una lista de entidades de tipo [T] basada en los parámetros proporcionados.
  ///
  /// [params] son los parámetros utilizados para obtener la lista de entidades.
  /// Retorna un `Future` que contiene un `Either<Failure, List<T>>`, donde `Failure` representa un error y `List<T>` la lista de entidades obtenidas.
  Future<Either<Failure, List<T>>> getList(ParamsGetList params);
}
