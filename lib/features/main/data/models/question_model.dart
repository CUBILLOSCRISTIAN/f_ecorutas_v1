import 'package:f_ecorutas_v1/features/main/domain/entity/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.id,
    required super.question,
    required super.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['pregunta'],
      answers: List<String>.from(json['opciones']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pregunta': question,
      'opciones': answers,
    };
  }
}
