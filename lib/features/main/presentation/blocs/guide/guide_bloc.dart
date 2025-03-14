import 'dart:async';

import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/finish_route_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/get_room_stream_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/load_questions_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_answer_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_question_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'guide_event.dart';
part 'guide_state.dart';

class GuideBloc extends Bloc<GuideEvent, GuideState> {
  final GetRoomStreamUsecase getRoomStreamUsecase;
  final SendQuestionUsecase sendQuestionUsecase;
  final SendAnswerUsecase sendAnswerUsecase;
  final FinishRouteUsecase finishRouteUsecase;
  final LoadQuestionsUsecase loadQuestionsUsecase;

  final String code;
  StreamSubscription? _subscription;

  GuideBloc({
    required this.getRoomStreamUsecase,
    required this.code,
    required this.sendQuestionUsecase,
    required this.sendAnswerUsecase,
    required this.finishRouteUsecase,
    required this.loadQuestionsUsecase,
  }) : super(GuideInitial()) {
    on<LoadGuideDataEvent>(_onLoadGuideData);
    on<SendQuestionEvent>(_onSendQuestion);
    on<FinishRouteEvent>(_onFinishRoute);
    on<LoadQuestionEvent>(_onLoadQuestion);
    // on<SelectQuestionEvent>(_onSelectQuestion);
    on<SelectItemEvent>((event, emit) {
      _onSelectQuestion(event, emit);
    });

    on<SendAnswerEvent>(_onSendAnswer);
  }

  Future<void> _onSelectQuestion(
    SelectItemEvent event,
    Emitter<GuideState> emit,
  ) async {
    final currentState = state;
    if (currentState is GuideLoaded) {
      print('Seleccionando pregunta ${event.selectedItem}');
      emit(currentState.copyWith(selectedItem: event.selectedItem));
    }
  }

  Future<void> _onLoadGuideData(
    LoadGuideDataEvent event,
    Emitter<GuideState> emit,
  ) async {
    emit(GuideLoading());

    final result = await loadQuestionsUsecase();
    late List<Question> questions;

    result.fold(
      (fail) => emit(GuideError('Error al cargar las preguntas')),
      (right) => questions = right,
    );

    await _subscription?.cancel(); // Cancelar la suscripción anterior si existe

    final stream = await getRoomStreamUsecase(code);

    await stream.fold(
      (fail) async {
        emit(GuideError('Error al obtener el stream'));
      },
      (stream) async => await emit.forEach(stream,
          onData: (snapshot) {
            if (!snapshot.exists) {
              return GuideError('No se encontró la sala');
            }

            final data = snapshot.data() as Map<String, dynamic>? ?? {};
            final participants = List<Map<String, dynamic>>.from(
              data['participantes'] ?? [],
            );
            final currentQuestion = data['pregunta_actual'] ?? '';

            // add(LoadGuideDataSuccess(participants, currentQuestion));
            return GuideLoaded(participants, questions);
          },
          onError: (error, stackTrace) =>
              GuideError('Error al cargar los datos: $error')),
    );
  }

  void _onLoadQuestion(
    LoadQuestionEvent event,
    Emitter<GuideState> emit,
  ) async {
    print('Cargando pregunta');
  }

  Future<void> _onSendQuestion(
    SendQuestionEvent event,
    Emitter<GuideState> emit,
  ) async {
    var result = await sendQuestionUsecase(code, event.questions);

    result.fold(
      (fail) => emit(GuideError('Error al enviar')),
      (right) => emit(GuideQuestionSent('Pregunta enviada')),
    );

    // result.fold((failure) => emit(GuideError('Error al enviar')), ()=>)
  }

  Future<void> _onSendAnswer(SendAnswerEvent event, Emitter<GuideState> emit) {
    //TODO implmentar
    print('asdasdasd');
  }

  Future<void> _onFinishRoute(
    FinishRouteEvent event,
    Emitter<GuideState> emit,
  ) async {
    await finishRouteUsecase(code);
  }

  @override
  Future<void> close() {
    _subscription?.cancel(); // Cancelar la suscripción cuando el BLoC se cierre
    return super.close();
  }
}
