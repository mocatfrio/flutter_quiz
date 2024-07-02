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
  late Future<List<Question>> _loadedQuestions;

  @override
  void initState() {
    super.initState();
    _loadedQuestions = _loadQuestions();
  }

  // Create
  Future<List<Question>> _addQuestion() async {
    final newQuestion = await Navigator.of(context).push<Question>(
      MaterialPageRoute(
        builder: (ctx) => const NewQuestion(),
      ),
    );

    if (newQuestion == null) {
      return _questions;
    }

    setState(() {
      _questions.add(newQuestion);
    });

    return _questions;
  }

  // Read
  Future<List<Question>> _loadQuestions() async {
    final url = Uri.https(
        'flutter-quiz-e62da-default-rtdb.firebaseio.com', 'question-list.json');

    final response = await http.get(url);

    // handling error
    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch data.');
    }

    // handling "No Data" case
    if (response.body == 'null') {
      return [];
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
    });

    return _questions;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question List'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _questions = _addQuestion() as List<Question>;
              });
            },
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
        child: FutureBuilder(
          future: _loadedQuestions,
          builder: (context, snapshot) {
            // if loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // handle error
            else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            // if data is empty
            else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No questions added yet!'),
              );
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Dismissible(
                  onDismissed: (direction) {
                    _removeQuestion(snapshot.data![index]);
                  },
                  key: ValueKey(snapshot.data![index].id),
                  child: ListTile(
                    title: Text(snapshot.data![index].text),
                    leading: Container(
                      width: 24,
                      height: 24,
                      color: snapshot.data![index].category.color,
                    ),
                    trailing:
                        Text(snapshot.data![index].answers.length.toString()),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
