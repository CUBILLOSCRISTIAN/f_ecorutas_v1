import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/main/domain/repositories/i_route_repository.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/get_room_stream_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_answer_usecase.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/foreground/foreground_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/foreground/foreground_event.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/participant/participant_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/route/route_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ParticipantScreen extends StatefulWidget {
  final String code;

  const ParticipantScreen({super.key, required this.code});

  @override
  State<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  @override
  void initState() {
    super.initState();
    _startListeningToData();
  }

  void _startListeningToData() {
    // Añadir un callback para recibir datos enviados desde el TaskHandler
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
  }

  void _onReceiveTaskData(dynamic data) {
    print('Data received: $data');
    if (data is Map<String, dynamic>) {
      // Pasar los datos al Repository

      getIt<IRouteRepository>().saveLocation(data);
    }
  }

  @override
  void dispose() {
    // Remover el callback cuando el widget se destruya
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ParticipantBloc(
            getRoomStreamUsecase: getIt<GetRoomStreamUsecase>(),
            sendAnswerUsecase: getIt<SendAnswerUsecase>(),
            code: widget.code,
          )..add(LoadParticipantDataEvent()),
        ),
        BlocProvider(
          create: (context) => ForegroundBloc(),
        ),
      ],
      child: BlocListener<ParticipantBloc, ParticipantState>(
        listenWhen: (previous, current) => current is ParticipantLoaded,
        listener: (context, state) {
          context.read<ForegroundBloc>().add(StartTracking());
        },
        child: _ParticipantView(),
      ),
    );
  }
}

class _ParticipantView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoRutas - Participante'),
      ),
      body: BlocListener<ParticipantBloc, ParticipantState>(
        listener: (context, state) => print(state),
        child: BlocBuilder<ParticipantBloc, ParticipantState>(
          builder: (context, state) {
            if (state is ParticipantLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ParticipantError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Volver')),
                ],
              );
            }

            if (state is ParticipantRouteFinished) {
              RouteBloc routeBloc = getIt<RouteBloc>();
              routeBloc.add(
                  FinishEvent(routeId: state.code, userId: state.userName));
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('Ruta finalizada')),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text('Volver'),
                  ),
                ],
              );
            }

            if (state is ParticipantLoaded) {
              return state.currentQuestion == '' || state.hasAnswered
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: Text(
                              'Esta atento a tu alrededor, es maravilloso, disfruta el momento, la pregunta llegará pronto... 🌳🌿🌱')),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Preguntas:',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            ...state.currentQuestion.map<Widget>((question) {
                              final questionId = question[
                                  'id']; // Identificador único de la pregunta
                              final selectedOption = state
                                      .selectedOptions?[questionId] ??
                                  -1; // Opción seleccionada (o -1 si no hay selección)

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question['pregunta'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Nada'),
                                        Text('Muchísimo'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: question['opciones']
                                          .map<Widget>(
                                            (opcion) => Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Radio(
                                                    value: question['opciones']
                                                        .indexOf(opcion),
                                                    groupValue: selectedOption,
                                                    onChanged: (value) {
                                                      context
                                                          .read<
                                                              ParticipantBloc>()
                                                          .add(
                                                            SelectOptionEvent(
                                                              questionId, // Identificador de la pregunta
                                                              value!, // Opción seleccionada
                                                            ),
                                                          );
                                                    },
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(opcion),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            }).toList(),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ParticipantBloc>().add(
                                      SendAnswerEvent(
                                        answers: state.selectedOptions ?? {},
                                      ),
                                    );
                              },
                              child: Text('Responder'),
                            ),
                          ],
                        ),
                      ),
                    );
            }

            return Center(child: Text('No se encontró la sala'));
          },
        ),
      ),
    );
  }
}
