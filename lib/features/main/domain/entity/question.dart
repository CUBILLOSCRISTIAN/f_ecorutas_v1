class Question {
  final int id;
  final String question;
  final List<String> answers;

  Question({
    required this.id,
    required this.question,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pregunta': question,
      'opciones': answers,
    };
  }
}
