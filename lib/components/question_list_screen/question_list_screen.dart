import 'dart:convert';

import 'package:adv_basic/components/question_list_screen/new_question.dart';
import 'package:adv_basic/data/categories.dart';
import 'package:adv_basic/models/question.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  List<Question> _questions = [];
  var _isLoading = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // Create
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

  // Read
  void _loadQuestions() async {
    final url = Uri.https(
        'flutter-quiz-e62da-default-rtdb.firebaseio.com', 'question-list.json');

    try {
      final response = await http.get(url);

      // handling error
      if (response.statusCode >= 400) {
        setState(() {
          _errorText = "Failed to fetch data. Please try again later :)";
        });
      }

      // handling "No Data" case
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listQuestion = json.decode(response.body);
      final List<Question> loadedQuestion = [];
      for (final question in listQuestion.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == question.value['category'])
            .value;
        final List<String> answers = question.value['answers'].cast<String>();
        loadedQuestion.add(Question(
            id: question.key,
            text: question.value['text'],
            answers: answers,
            category: category));
      }

      setState(() {
        _questions = loadedQuestion;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorText = 'Something went wrong! Please try again later.';
      });
    }
  }

  // Delete
  void _removeQuestion(Question question) async {
    final index = _questions.indexOf(question);

    setState(() {
      _questions.remove(question);
    });

    final url = Uri.https('flutter-quiz-e62da-default-rtdb.firebaseio.com',
        'question-list/${question.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _questions.insert(index, question);
      });
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No questions added yet!'),
    );

    // if loading
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

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

    // handling error
    if (_errorText != null) {
      content = Center(
        child: Text(_errorText!),
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
