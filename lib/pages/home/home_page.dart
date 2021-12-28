import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/models/card_stack.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/home/home_page_view.dart';
import 'package:simple_flashcards/pages/settings/settings_page.dart';
import 'package:simple_flashcards/pages/stack/stack_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageController createState() => HomePageController();
}

class HomePageController extends State<HomePage> {
  void createStackAction() async {
    final name = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.createNewStack,
      textFields: [DialogTextField(hintText: L10n.of(context)!.name)],
    );
    if (name == null || name.isEmpty) return;
    SimpleFlashcards.of(context).createStack(name.single);
  }

  void goToSettings() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        ),
      );

  void goToStack(String name) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StackPage(name),
        ),
      );

  List<CardStack> get stacks => SimpleFlashcards.of(context).stacks;

  void onReorder(int oldIndex, int newIndex) =>
      SimpleFlashcards.of(context).reorderStack(oldIndex, newIndex);

  void onReorderIconPressed() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.longPressToReorder),
        ),
      );

  @override
  Widget build(BuildContext context) => StreamBuilder<Object>(
        stream: SimpleFlashcards.of(context).stacksBox.watch(),
        builder: (_, __) => HomePageView(this),
      );
}
