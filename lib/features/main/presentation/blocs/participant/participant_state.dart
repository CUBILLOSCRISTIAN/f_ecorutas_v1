part of 'participant_bloc.dart';

abstract class ParticipantState extends Equatable {
  const ParticipantState();

  @override
  List<Object> get props => [];
}

class ParticipantInitial extends ParticipantState {}

class ParticipantLoading extends ParticipantState {}

class ParticipantLoaded extends ParticipantState {
  final dynamic currentQuestion;
  final int? selectedOption;
  final bool hasAnswered;

  const ParticipantLoaded(
    this.currentQuestion, {
    this.selectedOption = -1,
    this.hasAnswered = false,
  });

  ParticipantLoaded copyWith({
    dynamic currentQuestion,
    int? selectedOption,
    bool? hasAnswered,
  }) {
    return ParticipantLoaded(
      currentQuestion ?? this.currentQuestion,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  @override
  List<Object> get props =>
      [currentQuestion, selectedOption ?? -1, hasAnswered];
}

class ParticipantRouteFinished extends ParticipantState {
  final String code;
  final String userName;

  const ParticipantRouteFinished({
    required this.code,
    required this.userName,
  });

  @override
  List<Object> get props => [code, userName];
}

class ParticipantError extends ParticipantState {
  final String message;

  const ParticipantError(this.message);

  @override
  List<Object> get props => [message];
}
