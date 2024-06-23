import 'package:adv_basic/data/categories.dart';
import 'package:adv_basic/models/category.dart';
import 'package:adv_basic/models/question.dart';

final questions = [
  Question(
      id: '1',
      text: 'Berikut ini yang bukan merupakan fungsi Layer Transport adalah...',
      answers: ['Routing', 'Segmentasi', 'Flow control', 'Error control'],
      category: categories[Categories.computerNetwork]!),
  Question(
      id: '2',
      text: 'What are the main building blocks of Flutter UIs?',
      answers: ['Widgets', 'Components', 'Blocks', 'Functions'],
      category: categories[Categories.mobileProgramming]!),
  Question(
      id: '3',
      text: 'How are Flutter UIs built?',
      answers: [
        'By combining widgets in code',
        'By combining widgets in a visual editor',
        'By defining widgets in config files',
        'By using XCode for iOS and Android Studio for Android',
      ],
      category: categories[Categories.mobileProgramming]!),
  Question(
      id: '4',
      text: 'What\'s the purpose of a StatefulWidget?',
      answers: [
        'Update UI as data changes',
        'Update data as UI changes',
        'Ignore data changes',
        'Render UI that does not depend on data',
      ],
      category: categories[Categories.mobileProgramming]!),
  Question(
      id: '5',
      text:
          'Which widget should you try to use more often: StatelessWidget or StatefulWidget?',
      answers: [
        'StatelessWidget',
        'StatefulWidget',
        'Both are equally good',
        'None of the above',
      ],
      category: categories[Categories.mobileProgramming]!),
  Question(
      id: '6',
      text: 'What happens if you change data in a StatelessWidget?',
      answers: [
        'The UI is not updated',
        'The UI is updated',
        'The closest StatefulWidget is updated',
        'Any nested StatefulWidgets are updated',
      ],
      category: categories[Categories.mobileProgramming]!),
  Question(
      id: '7',
      text: 'How should you update data inside of StatefulWidgets?',
      answers: [
        'By calling setState()',
        'By calling updateData()',
        'By calling updateUI()',
        'By calling updateState()',
      ],
      category: categories[Categories.mobileProgramming]!)
];
