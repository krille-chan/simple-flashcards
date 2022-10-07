import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fast_csv/fast_csv.dart' as csv;
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'card_stack.dart';
import 'flash_card.dart';

class SimpleFlashcards {
  final Box stacksBox;
  final SharedPreferences preferences;

  SimpleFlashcards(this.stacksBox, this.preferences);

  static Future<SimpleFlashcards> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(AppConstants.dbName);
    final preferences = await SharedPreferences.getInstance();
    return SimpleFlashcards(box, preferences);
  }

  Widget builder(BuildContext context, Widget? child) => Provider(
        create: (_) => this,
        child: child,
        dispose: (_, __) => stacksBox.close(),
      );

  factory SimpleFlashcards.of(BuildContext context) =>
      Provider.of<SimpleFlashcards>(
        context,
        listen: false,
      );

  List<CardStack> get stacks => stacksBox.values
      .map((json) => CardStack.fromJson(Map<String, dynamic>.from(json)))
      .toList()
    ..sort((a, b) => b.sortOrder.compareTo(a.sortOrder));

  Future<void> createStack(String name) => stacksBox.put(
      name,
      CardStack(
        name: name,
        cards: [],
        sortOrder: DateTime.now().millisecondsSinceEpoch,
      ).toJson());

  Future<void> deleteStack(String name) => stacksBox.delete(name);

  Future<void> reorderStack(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final oldStack = stacks[oldIndex];
    final newStack = stacks[newIndex];
    final newSortOrder =
        newIndex > oldIndex ? newStack.sortOrder - 1 : newStack.sortOrder + 1;
    stacksBox.put(
        oldStack.name,
        CardStack(
          name: oldStack.name,
          cards: oldStack.cards,
          sortOrder: newSortOrder,
          emoji: oldStack.emoji,
        ).toJson());
  }

  CardStack? getStack(String name) {
    final stacks = stacksBox.get(name);
    if (stacks == null) return null;
    return CardStack.fromJson(Map<String, dynamic>.from(stacks));
  }

  Future<void> editStackName(String name, String newName) async {
    final stack = getStack(name)!;
    await stacksBox.delete(name);
    await stacksBox.put(
        newName,
        CardStack(
          name: newName,
          cards: stack.cards,
          sortOrder: stack.sortOrder,
          emoji: stack.emoji,
        ).toJson());
  }

  Future<void> editStackEmoji(String name, String? emoji) async {
    final stack = getStack(name)!;
    await stacksBox.put(
        name,
        CardStack(
          name: stack.name,
          cards: stack.cards,
          sortOrder: stack.sortOrder,
          emoji: emoji,
        ).toJson());
  }

  Future<void> addCardToStack(
    String stackName,
    String front,
    String back,
  ) async {
    final stack = getStack(stackName)!;
    final id = stack.cards
            .fold<int>(0, (prev, card) => card.id > prev ? card.id : prev) +
        1;
    stack.cards.add(FlashCard(
      front: front,
      back: back,
      selected: true,
      id: id,
    ));
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> deleteCardFromStack(String stackName, String front) async {
    final stack = getStack(stackName)!;
    stack.cards.removeWhere((card) => card.front == front);
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> editCardFront(String stackName, int id, String newFront) async {
    final stack = getStack(stackName)!;
    final card = stack.cards.singleWhere((card) => card.id == id);
    stack.cards.removeWhere((card) => card.id == id);
    stack.cards.add(FlashCard(
      front: newFront,
      back: card.back,
      id: card.id,
      selected: card.selected,
      level: card.level,
      lastLevelUp: card.lastLevelUp,
    ));
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> editCardBack(String stackName, int id, String newBack) async {
    final stack = getStack(stackName)!;
    final card = stack.cards.singleWhere((card) => card.id == id);
    stack.cards.removeWhere((card) => card.id == id);
    stack.cards.add(FlashCard(
      front: card.front,
      back: newBack,
      id: card.id,
      selected: card.selected,
      level: card.level,
      lastLevelUp: card.lastLevelUp,
    ));
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> editCardSelected(String stackName, int id, bool selected) async {
    final stack = getStack(stackName)!;
    final card = stack.cards.singleWhere((card) => card.id == id);
    stack.cards.removeWhere((card) => card.id == id);
    stack.cards.add(FlashCard(
      front: card.front,
      back: card.back,
      id: card.id,
      selected: selected,
      level: card.level,
      lastLevelUp: card.lastLevelUp,
    ));
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> editCardLevel(String stackName, int id, int level) async {
    final stack = getStack(stackName)!;
    final card = stack.cards.singleWhere((card) => card.id == id);
    stack.cards.removeWhere((card) => card.id == id);
    stack.cards.add(FlashCard(
      front: card.front,
      back: card.back,
      id: card.id,
      selected: card.selected,
      level: level,
      lastLevelUp: DateTime.now(),
    ));
    await stacksBox.put(stackName, stack.toJson());
  }

  void exportStack(String name) async {
    final stack = getStack(name)!;
    final csvData =
        stack.cards.map((card) => '"${card.front}","${card.back}"').join('\n');
    final csvBytes = Uint8List.fromList(utf8.encode(csvData));

    FilePickerCross(csvBytes, path: './$name.csv').exportToStorage();
  }

  Future<void> importFromCsv(String name, String data) async {
    final rows = csv.parse(data);

    await createStack(name);

    for (final cardRow in rows) {
      if (cardRow.length < 2) continue;
      final front = cardRow.first;
      final back = cardRow
          .sublist(1, cardRow.length)
          .where((s) => s.isNotEmpty)
          .join('\n');
      await addCardToStack(name, front, back);
    }
  }
}
