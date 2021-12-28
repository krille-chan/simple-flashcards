import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';
import 'package:simple_flashcards/pages/stack/stack_page_view.dart';
import 'package:yaru_icons/yaru_icons.dart';

class StackPage extends StatefulWidget {
  final String stackName;
  const StackPage(this.stackName, {Key? key}) : super(key: key);

  @override
  StackPageController createState() => StackPageController();
}

class StackPageController extends State<StackPage> {
  void deleteStackAction() async {
    final confirm = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.areYouSure,
      message: L10n.of(context)!.deleteStack,
      okLabel: L10n.of(context)!.yes,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (confirm != OkCancelResult.ok) return;
    final simpleFlashcards = SimpleFlashcards.of(context);
    Navigator.of(context).pop();
    simpleFlashcards.deleteStack(widget.stackName);
  }

  List<FlashCard> get cards =>
      (SimpleFlashcards.of(context).getStack(widget.stackName)?.cards ?? [])
        ..sort((b, a) => b.front.compareTo(a.front));

  void startSession() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SessionPage(widget.stackName),
        ),
      );

  void editName() async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.editStack,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.name,
          initialText: widget.stackName,
        )
      ],
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (input == null) return;
    SimpleFlashcards.of(context).editStackName(widget.stackName, input.single);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => StackPage(input.single)),
        (route) => route.isFirst);
  }

  void addFlashCard() async {
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
    SimpleFlashcards.of(context).addCardToStack(
      widget.stackName,
      textInput.first,
      textInput.last,
    );
  }

  void editCard(int index) async {
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
            icon: YaruIcons.insert_text,
          ),
          SheetAction(
            key: FlashCardAction.delete,
            isDestructiveAction: true,
            label: L10n.of(context)!.deleteFlashCard,
            icon: YaruIcons.trash,
          ),
        ]);
    if (action == null) return;
    if (action == FlashCardAction.delete) {
      await SimpleFlashcards.of(context)
          .deleteCardFromStack(widget.stackName, front);
      return;
    }
    final textInput = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.editFlashCard,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.front,
          initialText: card.front,
          maxLines: 2,
          validator: (s) => s != null && s.isNotEmpty
              ? null
              : L10n.of(context)!.pleaseFillOut,
        ),
        DialogTextField(
          hintText: L10n.of(context)!.back,
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
      SimpleFlashcards.of(context).editCardFront(
        widget.stackName,
        front,
        textInput.first,
      );
      front = textInput.first;
    }
    if (textInput.last != card.back) {
      SimpleFlashcards.of(context).editCardBack(
        widget.stackName,
        front,
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
