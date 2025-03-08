import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/get_room_stream_usecase.dart';
import 'package:f_ecorutas_v1/features/main/domain/usecases/send_answer_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'participant_event.dart';
part 'participant_state.dart';

class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  final GetRoomStreamUsecase _getRoomStreamUsecase;
  final SendAnswerUsecase _sendAnswerUsecase;
  final String code;
  StreamSubscription? _subscription;

  bool isAnswered = false;
  String _previousQuestion = '';

  ParticipantBloc({
    required this.code,
    required GetRoomStreamUsecase getRoomStreamUsecase,
    required SendAnswerUsecase sendAnswerUsecase,
  })  : _getRoomStreamUsecase = getRoomStreamUsecase,
        _sendAnswerUsecase = sendAnswerUsecase,
        super(ParticipantInitial()) {
    on<LoadParticipantDataEvent>(_onLoadParticipantData);
    on<SendAnswerEvent>(_onSendAnswer);
    on<SelectOptionEvent>(_onSelectOption);
  }

  Future<void> _onSelectOption(
    SelectOptionEvent event,
    Emitter<ParticipantState> emit,
  ) async {
    if (state is ParticipantLoaded) {
      emit((state as ParticipantLoaded).copyWith(selectedOption: event.option));
    }
  }

  Future<void> _onLoadParticipantData(
    LoadParticipantDataEvent event,
    Emitter<ParticipantState> emit,
  ) async {
    emit(ParticipantLoading());

    await _subscription?.cancel();

    final result = await _getRoomStreamUsecase(code);

    await result.fold(
      (error) async {
        emit(ParticipantError('Error al cargar los datos: $error'));
      },
      (stream) async {
        await emit.forEach(
          stream,
          onData: (snapshot) {
            if (!snapshot.exists) {
              return ParticipantError('No se encontró la sala');
            }

            final data = snapshot.data() as Map<String, dynamic>? ?? {};
            final currentQuestion = data['pregunta_actual'] ?? '';
            final status = data['status'] ?? 'esperando';

            if (currentQuestion != '' &&
                currentQuestion['pregunta'] != _previousQuestion) {
              _previousQuestion = currentQuestion['pregunta'];
              isAnswered = false;
            }

            if (status == 'finalizado') {
              return ParticipantRouteFinished(code: code, userName: '');
            } else {
              if (state is! ParticipantLoaded ||
                  (state as ParticipantLoaded).currentQuestion !=
                      currentQuestion) {
                return ParticipantLoaded(
                  currentQuestion,
                  hasAnswered: isAnswered,
                  selectedOption: -1, // Reiniciar la opción seleccionada
                );
              }
            }
            return state;
          },
          onError: (error, stackTrace) =>
              ParticipantError('Error al cargar los datos: $error'),
        );
      },
    );
  }

  Future<void> _onSendAnswer(
    SendAnswerEvent event,
    Emitter<ParticipantState> emit,
  ) async {
    if (state is ParticipantLoaded) {
      final currentState = state as ParticipantLoaded;
      final result =
          await _sendAnswerUsecase(code, event.answer, event.question);
      await result.fold(
        (error) async {
          emit(ParticipantError('Error al enviar la respuesta: $error'));
        },
        (_) async {
          isAnswered = true;
          emit(currentState.copyWith(hasAnswered: true));
        },
      );
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
