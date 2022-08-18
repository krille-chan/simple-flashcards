import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';
import 'package:simple_flashcards/pages/stack/stack_edit_bottom_sheet.dart';
import 'package:simple_flashcards/pages/stack/stack_page_view.dart';
import 'edit_stack_input.dart';

class StackPage extends StatefulWidget {
  final String stackName;
  const StackPage(this.stackName, {Key? key}) : super(key: key);

  @override
  StackPageController createState() => StackPageController();
}

class StackPageController extends State<StackPage> {
  void deleteStackAction() async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final navigator = Navigator.of(context);
    final confirm = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.areYouSure,
      message: L10n.of(context)!.deleteStack,
      okLabel: L10n.of(context)!.yes,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (confirm != OkCancelResult.ok) return;
    navigator.pop();
    simpleFlashcards.deleteStack(widget.stackName);
  }

  List<FlashCard> get cards =>
      (SimpleFlashcards.of(context).getStack(widget.stackName)?.cards ?? [])
        ..sort((a, b) => b.id.compareTo(a.id));

  void toggle(int id, bool selected) {
    SimpleFlashcards.of(context)
        .editCardSelected(widget.stackName, id, selected);
  }

  void toggleAll() {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final selected = cards.where((c) => c.selected);
    if (selected.isNotEmpty) {
      for (final card in selected) {
        simpleFlashcards.editCardSelected(
          widget.stackName,
          card.id,
          false,
        );
      }
    } else {
      for (final card in cards) {
        simpleFlashcards.editCardSelected(
          widget.stackName,
          card.id,
          true,
        );
      }
    }
  }

  void exportStack() =>
      SimpleFlashcards.of(context).exportStack(widget.stackName);

  void startSession() {
    final selectedCards = cards.where((card) => card.selected).toList();
    selectedCards.sort((a, b) => a.canLevelUp && b.canLevelUp
        ? a.level.compareTo(b.level)
        : a.canLevelUp
            ? 1
            : -1);
    final learningCards = selectedCards.take(20).toList();
    learningCards.shuffle();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SessionPage(
          stackName: widget.stackName,
          flashCards: learningCards,
        ),
      ),
    );
  }

  void editName() async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final navigator = Navigator.of(context);

    final input = await showModalBottomSheet<EditStackInput>(
      context: context,
      builder: (c) => StackEditBottomSheet(
        currentName: widget.stackName,
      ),
    );

    if (input == null) return;
    final emoji = input.emoji;
    if (emoji != null) {
      await simpleFlashcards.editStackEmoji(widget.stackName, input.emoji);
    }
    if (widget.stackName != input.name) {
      await simpleFlashcards.editStackName(widget.stackName, input.name);
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => StackPage(input.name)),
          (route) => route.isFirst);
    }
  }

  void addFlashCard() async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final textInput = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.addNewFlashCard,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.front,
          maxLines: 2,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
        DialogTextField(
          hintText: L10n.of(context)!.back,
          maxLines: 2,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
      ],
    );
    if (textInput == null) return;
    simpleFlashcards.addCardToStack(
      widget.stackName,
      textInput.first,
      textInput.last,
    );
  }

  void editCard(int index) async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final l10n = L10n.of(context)!;
    final card = cards[index];
    String front = card.front;
    final action = await showModalActionSheet<FlashCardAction>(
        context: context,
        title: front,
        message: card.back,
        actions: [
          SheetAction(
            key: FlashCardAction.edit,
            isDefaultAction: true,
            label: L10n.of(context)!.editFlashCard,
            icon: Icons.edit_outlined,
          ),
          SheetAction(
            key: FlashCardAction.delete,
            isDestructiveAction: true,
            label: L10n.of(context)!.deleteFlashCard,
            icon: Icons.delete_outlined,
          ),
        ]);
    if (action == null) return;
    if (action == FlashCardAction.delete) {
      await simpleFlashcards.deleteCardFromStack(widget.stackName, front);
      return;
    }
    final textInput = await showTextInputDialog(
      context: context,
      title: l10n.editFlashCard,
      textFields: [
        DialogTextField(
          hintText: l10n.front,
          initialText: card.front,
          maxLines: 2,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
        DialogTextField(
          hintText: l10n.back,
          initialText: card.back,
          maxLines: 2,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
      ],
    );
    if (textInput == null) return;
    if (textInput.first != front) {
      simpleFlashcards.editCardFront(
        widget.stackName,
        card.id,
        textInput.first,
      );
      front = textInput.first;
    }
    if (textInput.last != card.back) {
      simpleFlashcards.editCardBack(
        widget.stackName,
        card.id,
        textInput.last,
      );
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Object>(
        stream: SimpleFlashcards.of(context).stacksBox.watch(),
        builder: (_, __) => StackPageView(this),
      );
}

enum FlashCardAction { edit, delete }
