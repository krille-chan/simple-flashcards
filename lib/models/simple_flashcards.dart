import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'card_stack.dart';
import 'flash_card.dart';

class SimpleFlashcards {
  final Box stacksBox;

  SimpleFlashcards(this.stacksBox);

  static Future<SimpleFlashcards> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(AppConstants.dbName);
    return SimpleFlashcards(box);
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
    await stacksBox.put(
        oldStack.name,
        CardStack(
          name: oldStack.name,
          cards: oldStack.cards,
          sortOrder: newStack.sortOrder,
        ).toJson());
    await stacksBox.put(
        newStack.name,
        CardStack(
          name: newStack.name,
          cards: newStack.cards,
          sortOrder: oldStack.sortOrder,
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
        ).toJson());
  }

  Future<void> addCardToStack(
    String stackName,
    String front,
    String back,
  ) async {
    final stack = getStack(stackName)!;
    stack.cards.add(FlashCard(front: front, back: back));
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> deleteCardFromStack(String stackName, String front) async {
    final stack = getStack(stackName)!;
    stack.cards.removeWhere((card) => card.front == front);
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> editCardFront(
      String stackName, String front, String newFront) async {
    final stack = getStack(stackName)!;
    final card = stack.cards.singleWhere((card) => card.front == front);
    stack.cards.removeWhere((card) => card.front == front);
    stack.cards.add(FlashCard(front: newFront, back: card.back));
    await stacksBox.put(stackName, stack.toJson());
  }

  Future<void> editCardBack(String stackName, String front, String back) async {
    final stack = getStack(stackName)!;
    stack.cards.removeWhere((card) => card.front == front);
    stack.cards.add(FlashCard(front: front, back: back));
    await stacksBox.put(stackName, stack.toJson());
  }

  Map<String, dynamic> exportToJson() =>
      {'stacks': stacks.map((s) => s.toJson()).toList()};

  Future<void> importFromJson(Map<String, dynamic> json) async {
    await stacksBox.clear();
    await stacksBox.putAll(json['stacks']);
  }

  Future<Uint8List> exportToFile() async {
    final json = exportToJson();
    return Uint8List.fromList(jsonEncode(json).codeUnits);
  }
}