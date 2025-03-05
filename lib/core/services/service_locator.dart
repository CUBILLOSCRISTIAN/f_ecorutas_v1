import 'package:f_ecorutas_v1/features/main/data/repositories/guide_repository_impl.dart';
import 'package:f_ecorutas_v1/features/main/data/repositories/route_repository_impl.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/local/i_local_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/local/local_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/firebase_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_guide_repository.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/create_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/finish_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/get_room_stream_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/join_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/load_questions_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_answer_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_question_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/sent_positions_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/start_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/start_traing_usecase.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/role_selection/role_selection_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/route/route_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  //Services
  getIt.registerSingleton<IRemoteDatasource>(FirebaseDataSource());
  getIt.registerSingleton<ILocalDatasource>(LocalDatasource());

  //Repositories

  getIt.registerSingleton<IRouteRepository>(
    RouteRepositoryImpl(
      getIt<IRemoteDatasource>(),
      getIt<ILocalDatasource>(),
    ),
  );

  getIt.registerSingleton<IGuideRepository>(
    GuideRepositoryImpl(
      getIt<ILocalDatasource>(),
      getIt<IRemoteDatasource>(),
    ),
  );

  //UseCases

  getIt.registerSingleton<CreateRouteUsecase>(
      CreateRouteUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<JoinRouteUsecase>(
      JoinRouteUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<FinishRouteUsecase>(
      FinishRouteUsecase(getIt<IGuideRepository>()));
  getIt.registerSingleton<StartRouteUsecase>(
      StartRouteUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<GetRoomStreamUsecase>(
      GetRoomStreamUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<SendQuestionUsecase>(
      SendQuestionUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<SendAnswerUsecase>(
      SendAnswerUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<LoadQuestionsUsecase>(
      LoadQuestionsUsecase(getIt<IGuideRepository>()));
  getIt.registerSingleton<SentPositionsUsecase>(
      SentPositionsUsecase(getIt<IRouteRepository>()));

  getIt.registerSingleton<StartTraingUsecase>(
      StartTraingUsecase(getIt<IRouteRepository>()));

  //Blocs

  getIt.registerSingleton<RouteBloc>(RouteBloc(
    createRouteUsecase: getIt<CreateRouteUsecase>(),
    joinRouteUsecase: getIt<JoinRouteUsecase>(),
    sentPositionsUsecase: getIt<SentPositionsUsecase>(),
    startRouteUsecase: getIt<StartRouteUsecase>(),
    startTraingUsecase: getIt<StartTraingUsecase>(),
  ));

  // Registra el BLoC como una instancia única (singleton)
  getIt.registerSingleton<RoleSelectionBloc>(RoleSelectionBloc());
}
