import 'package:f_ecorutas_v1/core/services/service_locator.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/finish_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/get_room_stream_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/load_questions_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_answer_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_question_usecase.dart';
import 'package:f_ecorutas_v1/features/main/presentation/blocs/guide/guide_bloc.dart';
import 'package:f_ecorutas_v1/features/main/presentation/widgets/code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuideScreen extends StatelessWidget {
  final String code;

  const GuideScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuideBloc(
        getRoomStreamUsecase: getIt<GetRoomStreamUsecase>(),
        sendQuestionUsecase: getIt<SendQuestionUsecase>(),
        sendAnswerUsecase: getIt<SendAnswerUsecase>(),
        finishRouteUsecase: getIt<FinishRouteUsecase>(),
        loadQuestionsUsecase: getIt<LoadQuestionsUsecase>(),
        code: code,
      )..add(LoadGuideDataEvent()),
      child: _GuideView(),
    );
  }
}

class _GuideView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoRutas - Guía'),
      ),
      body: BlocBuilder<GuideBloc, GuideState>(
        builder: (context, state) {
          if (state is GuideLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is GuideError) {
            return Center(child: Text(state.message));
          }

          if (state is GuideLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CodeCard(
                      code: context.read<GuideBloc>().code,
                      subTitle: 'Participantes: ${state.participants.length}'),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        final question = state.questions[index];
                        return RadioListTile(
                          title: Text(question.question),
                          value: index,
                          groupValue: state.selectedIndex,
                          onChanged: (value) {
                            context
                                .read<GuideBloc>()
                                .add(SelectQuestionEvent(value!));
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // _sendQuestion(context);
                      context.read<GuideBloc>().add(SendQuestionEvent(
                          state.questions[state.selectedIndex!].toJson()));
                    },
                    child: Text('Enviar Pregunta'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GuideBloc>().add(FinishRouteEvent());
                    },
                    child: Text('Finalizar Ruta'),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No se encontró la sala'));
        },
      ),
    );
  }
}
