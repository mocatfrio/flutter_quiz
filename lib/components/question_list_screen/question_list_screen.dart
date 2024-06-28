import 'package:adv_basic/components/question_list_screen/new_question.dart';
import 'package:adv_basic/data/questions.dart';
import 'package:adv_basic/models/question.dart';
import 'package:flutter/material.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  final List<Question> _questions = [];

  void _addQuestion() async {
    final newQuestion = await Navigator.of(context).push<Question>(
      MaterialPageRoute(
        builder: (ctx) => const NewQuestion(),
      ),
    );

    if (newQuestion == null) {
      return;
    }

    setState(() {
      _questions.add(newQuestion);
    });
  }

  void _removeQuestion(Question question) {
    setState(() {
      _questions.remove(question);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No questions added yet!'),
    );

    if (_questions.isNotEmpty) {
      content = ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeQuestion(_questions[index]);
          },
          key: ValueKey(_questions[index].id),
          child: ListTile(
            title: Text(_questions[index].text),
            leading: Container(
              width: 24,
              height: 24,
              color: _questions[index].category.color,
            ),
            trailing: Text(_questions[index].answers.length.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question List'),
        actions: [
          IconButton(
            onPressed: _addQuestion,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 78, 13, 151),
              Color.fromARGB(255, 107, 15, 168)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: content),
    );
  }
}
