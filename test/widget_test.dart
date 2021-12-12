import 'package:flutter_test/flutter_test.dart';

import 'package:simple_flashcards/main.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';

void main() {
  testWidgets('Test if app starts', (WidgetTester tester) async {
    final simpleFlashcards = await SimpleFlashcards.init();
    await tester.pumpWidget(SimpleFlashcardsApp(simpleFlashcards));
  });
}
