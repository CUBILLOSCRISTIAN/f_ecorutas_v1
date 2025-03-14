part of 'guide_bloc.dart';

abstract class GuideEvent extends Equatable {
  const GuideEvent();

  @override
  List<Object> get props => [];
}

class LoadGuideDataEvent extends GuideEvent {
  const LoadGuideDataEvent();
}

class SendQuestionEvent extends GuideEvent {
  final List<Question> questions;

  const SendQuestionEvent(this.questions);

  @override
  List<Object> get props => [questions];
}

class FinishRouteEvent extends GuideEvent {
  const FinishRouteEvent();
}

class LoadGuideDataSuccess extends GuideEvent {
  final List<Map<String, dynamic>> participants;
  final String currentQuestion;

  const LoadGuideDataSuccess(this.participants, this.currentQuestion);

  @override
  List<Object> get props => [participants, currentQuestion];
}

class LoadQuestionEvent extends GuideEvent {
  const LoadQuestionEvent();
}

class SelectQuestionEvent extends GuideEvent {
  final String selectedItem;

  const SelectQuestionEvent(this.selectedItem);

  @override
  List<Object> get props => [selectedItem];
}

class SelectItemEvent extends GuideEvent {
  final String selectedItem;
  const SelectItemEvent(this.selectedItem);

  @override
  List<Object> get props => [selectedItem];
}
