import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/get_room_stream_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_answer_usecase.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/participant/participant_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/route/route_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantScreen extends StatelessWidget {
  final String code;

  const ParticipantScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParticipantBloc(
        getRoomStreamUsecase: getIt<GetRoomStreamUsecase>(),
        sendAnswerUsecase: getIt<SendAnswerUsecase>(),
        code: code,
      )..add(LoadParticipantDataEvent()),
      child: _ParticipantView(),
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
              return Center(child: Text(state.message));
            }

            if (state is ParticipantRouteFinished) {
              RouteBloc routeBloc = getIt<RouteBloc>();
              routeBloc.add(
                  FinishEvent(routeId: state.code, userId: state.userName));
              return Center(
                child: Text(
                  'La ruta ha finalizado. ¡Gracias por participar!',
                  style: TextStyle(fontSize: 24),
                ),
              );
            }

            if (state is ParticipantLoaded) {
              RouteBloc routeBloc = getIt<RouteBloc>();
              routeBloc.add(StartTrankingEvent());

              return state.currentQuestion == '' || state.hasAnswered
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: Text(
                              'Esta atento a tu alrededor, es maravilloso, disfruta el momento, la pregunta llegará pronto... 🌳🌿🌱')),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Pregunta actual:',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            state.currentQuestion['pregunta'],
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: state.currentQuestion['opciones']
                                .map<Widget>(
                                  (opcion) => RadioListTile(
                                    title: Text(opcion),
                                    value: state.currentQuestion['opciones']
                                        .indexOf(opcion),
                                    groupValue: state.selectedOption,
                                    onChanged: (value) {
                                      context
                                          .read<ParticipantBloc>()
                                          .add(SelectOptionEvent(value!));
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ParticipantBloc>().add(
                                    SendAnswerEvent(
                                      answer: state.currentQuestion['opciones']
                                          [state.selectedOption],
                                      question:
                                          state.currentQuestion['pregunta'],
                                    ),
                                  );
                            },
                            child: Text('Responder'),
                          ),
                        ],
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
