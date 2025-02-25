import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';

abstract interface class IListRemote<T, ParamsGetList> {
  /// Obtiene una lista de entidades de tipo [T] basada en los parámetros proporcionados.
  ///
  /// [params] son los parámetros utilizados para obtener la lista de entidades.
  /// Retorna un `List<T>`, donde `List<T>` la lista de entidades obtenidas.
  Future<Either<Failure, List<T>>> fetchList(ParamsGetList params);
}
