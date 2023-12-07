import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/session/card.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';

class SessionPageView extends StatelessWidget {
  final SessionPageController controller;
  const SessionPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: controller.repeatAllCards,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      icon: const Icon(Icons.repeat_outlined),
                      label: Text(L10n.of(context)!.repeatAllCards),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: controller.nextCards,
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
                      padding: const EdgeInsets.all(16.0),
                      child: CardWidget(controller),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: controller.cardNotKnown,
                      icon: const Icon(Icons.repeat_outlined),
                      label: Text(L10n.of(context)!.repeat),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: controller.cardKnown,
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
