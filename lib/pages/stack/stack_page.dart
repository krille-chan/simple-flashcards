import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/settings_keys.dart';
import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/ai_session/ai_session_page.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';
import 'package:simple_flashcards/pages/stack/stack_page_view.dart';
import 'package:simple_flashcards/pages/stack/text_input_scaffold.dart';

class StackPage extends StatefulWidget {
  final String stackName;
  const StackPage(this.stackName, {super.key});

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

  bool get openAiApiKeyEnabled =>
      SimpleFlashcards.of(context)
          .preferences
          .getString(SettingsKeys.openAiApiKey) !=
      null;

  void exportStack() =>
      SimpleFlashcards.of(context).exportStack(widget.stackName);

  void startSession(SessionType sessionType) async {
    final selectedCards =
        List<FlashCard>.from(cards.where((card) => card.selected));
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
    final rerun = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) {
          switch (sessionType) {
            case SessionType.interrogate:
              return SessionPage(
                stackName: widget.stackName,
                flashCards: learningCards,
              );
            case SessionType.ai:
              return AiSessionPage(
                stackName: widget.stackName,
                flashCards: learningCards,
              );
          }
        },
      ),
    );
    if (rerun == true && mounted) startSession(sessionType);
  }

  void editName() async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.editStack,
      textFields: [
        DialogTextField(
            initialText: widget.stackName, hintText: L10n.of(context)!.name),
      ],
      okLabel: L10n.of(context)!.save,
      cancelLabel: L10n.of(context)!.cancel,
    );
    final newName = input?.singleOrNull;
    if (newName == null) return;
    if (!mounted) return;
    await SimpleFlashcards.of(context).editStackName(widget.stackName, newName);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => StackPage(newName)),
        (route) => route.isFirst);
  }

  void deleteStack() async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.areYouSure,
      message: L10n.of(context)!.deleteStack,
      okLabel: L10n.of(context)!.deleteStack,
      cancelLabel: L10n.of(context)!.cancel,
      isDestructiveAction: true,
    );
    if (consent != OkCancelResult.ok) return;
    if (!mounted) return;
    await simpleFlashcards.deleteStack(widget.stackName);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void editEmoji() async {
    final simpleFlashcards = SimpleFlashcards.of(context);

    final emoji = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 400,
          height: 256,
          child: EmojiPicker(
            config: const Config(
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: Colors.transparent,
                ),
                categoryViewConfig: CategoryViewConfig(
                  backgroundColor: Colors.transparent,
                  initCategory: Category.OBJECTS,
                ),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: Colors.transparent,
                )),
            onEmojiSelected: (_, e) =>
                Navigator.of(context).pop<String>(e.emoji),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L10n.of(context)!.cancel),
          )
        ],
      ),
    );
    if (emoji == null) return;
    if (!mounted) return;
    await simpleFlashcards.editStackEmoji(widget.stackName, emoji);
    setState(() {});
  }

  void addFlashCard() async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final l10n = L10n.of(context)!;
    final newCard = await Navigator.of(context).push(
      MaterialPageRoute<FlashCard?>(
        builder: (_) => const TextInputScaffold(),
      ),
    );
    if (newCard == null) return;
    if (cards.any((c) =>
        c.front.trim().toLowerCase() == newCard.front.trim().toLowerCase())) {
      if (!mounted) return;
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
      newCard.front,
      newCard.back,
      hint: newCard.hint,
    );
  }

  void editCard(int index) async {
    final simpleFlashcards = SimpleFlashcards.of(context);
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
    if (!mounted) return;
    final editedCard = await Navigator.of(context).push(
      MaterialPageRoute<FlashCard?>(
        builder: (_) => TextInputScaffold(
          flashCard: card,
        ),
      ),
    );
    if (editedCard == null) return;
    if (editedCard.front != front) {
      simpleFlashcards.editCardFront(
        widget.stackName,
        card.id,
        editedCard.front,
      );
      front = editedCard.front;
    }
    if (editedCard.back != card.back) {
      simpleFlashcards.editCardBack(
        widget.stackName,
        card.id,
        editedCard.back,
      );
    }

    if (editedCard.hint != card.hint) {
      simpleFlashcards.editCardHint(
        widget.stackName,
        card.id,
        editedCard.hint,
      );
    }
  }

  void onPopupMenuStackAction(PopupMenuStackAction action) {
    switch (action) {
      case PopupMenuStackAction.export:
        exportStack();
      case PopupMenuStackAction.selectAll:
        toggleAll();
      case PopupMenuStackAction.edit:
        editName();
      case PopupMenuStackAction.delete:
        deleteStack();
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Object>(
        stream: SimpleFlashcards.of(context).stacksBox.watch(),
        builder: (_, __) => StackPageView(this),
      );
}

enum FlashCardAction { edit, delete }

enum SessionType { interrogate, ai }

enum PopupMenuStackAction { export, selectAll, edit, delete }
