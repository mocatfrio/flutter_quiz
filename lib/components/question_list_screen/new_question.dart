import 'package:adv_basic/data/categories.dart';
import 'package:adv_basic/models/category.dart';
import 'package:adv_basic/models/question.dart';
import 'package:flutter/material.dart';

class NewQuestion extends StatefulWidget {
  const NewQuestion({super.key});

  @override
  State<NewQuestion> createState() {
    return _NewQuestionState();
  }
}

class _NewQuestionState extends State<NewQuestion> {
  final _formKey = GlobalKey<FormState>();
  var _enteredQuestion = '';
  var _enteredAnswers = '';
  var _selectedCategory = Categories.mobileProgramming;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        Question(
          id: DateTime.now().toString(), 
          text: _enteredQuestion, 
          answers: [_enteredAnswers], 
          category: categories[_selectedCategory]!
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Question'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredQuestion = value!;
                },
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Answers"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredAnswers = value!;
                },
              ),
              DropdownButton(
                hint: const Text('Select Category'),
                value: _selectedCategory,
                items: [
                  for (final category in categories.entries)
                    DropdownMenuItem(
                      value: category.key,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: category.value.color,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(category.value.title)
                        ],
                      ),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
