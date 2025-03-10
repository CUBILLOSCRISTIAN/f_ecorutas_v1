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
  final String answer;
  final String question;

  const SendAnswerEvent({
    required this.answer,
    required this.question,
  });

  @override
  List<Object> get props => [answer, question];
}

class SelectOptionEvent extends ParticipantEvent {
  final int option;

  const SelectOptionEvent(this.option);

  @override
  List<Object> get props => [option];
}

class CleanEvent extends ParticipantEvent {
  const CleanEvent();
}
