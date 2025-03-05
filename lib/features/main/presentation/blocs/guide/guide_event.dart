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
  final Map<String, dynamic> question;

  const SendQuestionEvent(this.question);

  @override
  List<Object> get props => [question];
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
  final int selectedIndex;

  const SelectQuestionEvent(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
