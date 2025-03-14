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

  final bool hasAnswered;

  final Map<int, int>? selectedOptions;

  const ParticipantLoaded(
    this.currentQuestion, {
    this.hasAnswered = false,
    this.selectedOptions = const {},
  });

  ParticipantLoaded copyWith({
    dynamic currentQuestion,
    int? selectedOption,
    bool? hasAnswered,
    Map<int, int>? selectedOptions,
  }) {
    return ParticipantLoaded(
      currentQuestion ?? this.currentQuestion,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  @override
  List<Object> get props =>
      [hasAnswered, selectedOptions ?? {}, currentQuestion];
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
