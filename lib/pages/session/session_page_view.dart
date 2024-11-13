import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/session/card.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';

class SessionPageView extends StatelessWidget {
  final SessionPageController controller;
  const SessionPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.cards.isEmpty
              ? L10n.of(context)!.allCardsFinished
              : L10n.of(context)!.cardsLeft(
                  controller.cards.length.toString(),
                ),
        ),
      ),
      body: SafeArea(
        child: controller.cards.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(spacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: spacing),
                    ElevatedButton.icon(
                      onPressed: controller.isLoadingNextCard
                          ? null
                          : controller.repeatAllCards,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      icon: const Icon(Icons.repeat_outlined),
                      label: Text(L10n.of(context)!.repeatAllCards),
                    ),
                    const SizedBox(height: spacing),
                    ElevatedButton.icon(
                      onPressed: controller.isLoadingNextCard
                          ? null
                          : controller.nextCards,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      icon: const Icon(Icons.send_outlined),
                      label: Text(L10n.of(context)!.nextCards),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(spacing),
                      child: CardWidget(controller),
                    ),
                  ),
                  const SizedBox(height: spacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: spacing),
                    child: ElevatedButton.icon(
                      onPressed: controller.isLoadingNextCard
                          ? null
                          : controller.cardNotKnown,
                      icon: const Icon(Icons.repeat_outlined),
                      label: Text(L10n.of(context)!.repeat),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  if (controller.typeAnswer)
                    Padding(
                      padding: const EdgeInsets.all(spacing),
                      child: TextField(
                        readOnly: controller.isLoadingNextCard,
                        maxLines: 1,
                        focusNode: controller.answerFocusNode,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          controller.answerFocusNode.requestFocus();
                          controller.checkTypeAnswer();
                        },
                        controller: controller.anserTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90),
                            borderSide: controller.wrongTypeAnswer
                                ? const BorderSide(width: 1)
                                : BorderSide.none,
                          ),
                          hintText: L10n.of(context)!.typeAnswer,
                          filled: true,
                          error: controller.wrongTypeAnswer
                              ? const SizedBox.shrink()
                              : null,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send_outlined),
                            onPressed: controller.checkTypeAnswer,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(spacing),
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoadingNextCard
                            ? null
                            : controller.cardKnown,
                        icon: const Icon(Icons.check_outlined),
                        label: Text(L10n.of(context)!.known),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
