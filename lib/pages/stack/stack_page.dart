import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/settings_keys.dart';
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
  final TextEditingController searchController = TextEditingController();
  String? searchTerm;

  List<FlashCard> get cards =>
      (SimpleFlashcards.of(context).getStack(widget.stackName)?.cards ?? [])
        ..sort((a, b) => b.id.compareTo(a.id));

  void toggle(int id, bool selected) {
    SimpleFlashcards.of(context)
        .editCardSelected(widget.stackName, id, selected);
  }

  void onSearch(String? searchTerm) {
    setState(() {
      this.searchTerm = searchTerm?.trim().toLowerCase();
    });
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
        ? b.level.compareTo(a.level)
        : a.canLevelUp
            ? -1
            : 1);
    final cardsPerSession = SimpleFlashcards.of(context)
            .preferences
            .getInt(SettingsKeys.cardsPerSessionKey) ??
        SettingsKeys.defaultCardsPerSessionKey;
    final learningCards = selectedCards.take(cardsPerSession).toList();
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
    final l10n = L10n.of(context)!;
    final textInput = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.addNewFlashCard,
      barrierDismissible: false,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.front,
          maxLines: 4,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
        DialogTextField(
          hintText: L10n.of(context)!.back,
          maxLines: 4,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
      ],
    );
    if (textInput == null) return;
    if (cards.any((c) =>
        c.front.trim().toLowerCase() == textInput.first.trim().toLowerCase())) {
      final duplicationConsent = await showOkCancelAlertDialog(
        context: context,
        title: l10n.cardAlreadyExists,
        okLabel: l10n.createAnyway,
        cancelLabel: l10n.cancel,
      );
      if (duplicationConsent != OkCancelResult.ok) return;
    }
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
      barrierDismissible: false,
      textFields: [
        DialogTextField(
          hintText: l10n.front,
          initialText: card.front,
          maxLines: 4,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
        DialogTextField(
          hintText: l10n.back,
          initialText: card.back,
          maxLines: 4,
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
