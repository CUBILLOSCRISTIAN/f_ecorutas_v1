import 'package:dartz/dartz.dart';
import 'package:f_ecorutas_v1/core/error/failure.dart';
import 'package:f_ecorutas_v1/features/main/data/models/question_model.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/local/i_local_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_guide_repository.dart';

class GuideRepositoryImpl implements IGuideRepository {
  final ILocalDatasource _localDatasource;
  final IRemoteDatasource _remoteDatasource;

  const GuideRepositoryImpl(this._localDatasource, this._remoteDatasource);

  @override
  Future<Either<Failure, List<QuestionModel>>> loadQuestions() {
    return _localDatasource.loadQuestions();
  }

  @override
  Future<Either<Failure, Unit>> finishRoute(String routeId) async {
    return await _remoteDatasource.finishRoute(routeId);
  }
}
