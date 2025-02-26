import 'package:f_ecorutas_v1/features/main/data/repositories/route_repository_impl.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/firebase_datasource.dart';
import 'package:f_ecorutas_v1/features/main/data/sources/remote/i_remote_datasource.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/create_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/finish_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/join_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/role_selection/role_selection_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/route/route_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  //Services
  getIt.registerSingleton<IRemoteDatasource>(FirebaseDataSource());

  //Repositories

  getIt.registerSingleton<IRouteRepository>(
    RouteRepositoryImpl(
      getIt<IRemoteDatasource>(),
    ),
  );

  getIt.registerSingleton<CreateRouteUsecase>(
      CreateRouteUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<JoinRouteUsecase>(
      JoinRouteUsecase(getIt<IRouteRepository>()));
  getIt.registerSingleton<FinishRouteUsecase>(
      FinishRouteUsecase(getIt<IRouteRepository>()));

  getIt.registerSingleton<RouteBloc>(RouteBloc(
    getIt<CreateRouteUsecase>(),
    getIt<JoinRouteUsecase>(),
    getIt<FinishRouteUsecase>(),
  ));

  // Registra el BLoC como una instancia única (singleton)
  getIt.registerSingleton<RoleSelectionBloc>(RoleSelectionBloc());
}
