part of 'participant_bloc.dart';

abstract class ParticipantEvent extends Equatable {
  const ParticipantEvent();

  @override
  List<Object> get props => [];
}

class LoadParticipantDataEvent extends ParticipantEvent {
  const LoadParticipantDataEvent();
}

class SendAnswerEvent extends ParticipantEvent {
  final Map<int, int> answers;

  const SendAnswerEvent({
    required this.answers,
  });

  @override
  List<Object> get props => [answers];
}

class SelectOptionEvent extends ParticipantEvent {
  final int questionId; // Identificador de la pregunta
  final int selectedOption; // Opción seleccionada

  const SelectOptionEvent(this.questionId, this.selectedOption);

  @override
  List<Object> get props => [questionId, selectedOption];
}

class CleanEvent extends ParticipantEvent {
  const CleanEvent();
}
