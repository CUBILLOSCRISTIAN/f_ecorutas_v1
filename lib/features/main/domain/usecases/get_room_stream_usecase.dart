import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';

class GetRoomStreamUsecase {
  final IRouteRepository _repository;

  GetRoomStreamUsecase(this._repository);

  Future<Either<Failure, Stream<dynamic>>> call(String code) async {
    return await _repository.getRoomStream(code);
  }
}
