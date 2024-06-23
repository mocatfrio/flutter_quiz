import 'package:adv_basic/models/category.dart';

class Question {
  const Question({required this.id, required this.text, required this.answers, required this.category});

  final String id;
  final String text;
  final List<String> answers;
  final Category category;

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
