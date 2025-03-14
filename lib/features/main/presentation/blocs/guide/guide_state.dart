part of 'guide_bloc.dart';

abstract class GuideState extends Equatable {
  const GuideState();

  @override
  List<Object> get props => [];
}

class GuideInitial extends GuideState {}

class GuideLoading extends GuideState {}

class GuideLoaded extends GuideState {
  final List<Map<String, dynamic>> participants;
  final List<Question> questions;
  final int? selectedIndex;

  final String? selectedCategory;
  final String? selectedSubCategory;

  final List<String> subCategories = [
    'Subcategoria 1',
  ];
  final List<String> categories = [
    'Categoría 1',
    'Categoría 2',
    'Categoría 3',
    'Categoría 4',
    'Categoría 5',
  ];

  GuideLoaded(
    this.participants,
    this.questions, {
    this.selectedIndex = -1,
    this.selectedCategory = 'Categoría 1',
    this.selectedSubCategory = 'Subcategoría 1',
  });

  GuideLoaded copyWith({
    List<Map<String, dynamic>>? participants,
    List<Question>? questions,
    int? selectedIndex,
  }) {
    return GuideLoaded(
      participants ?? this.participants,
      questions ?? this.questions,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [participants, questions, selectedIndex ?? -1];
}

class GuideError extends GuideState {
  final String message;

  const GuideError(this.message);

  @override
  List<Object> get props => [message];
}
