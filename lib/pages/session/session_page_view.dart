import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/session/card.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';

class SessionPageView extends StatelessWidget {
  final SessionPageController controller;
  const SessionPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.allCardsFinished),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  controller.notKnownCards.isEmpty ? '🎉' : '👍',
                  style: const TextStyle(fontSize: 120),
                ),
              ),
              const SizedBox(height: 16),
              if (controller.notKnownCards.isNotEmpty)
                ElevatedButton(
                  onPressed: controller.repeatNotKnownCards,
                  child: Text(L10n.of(context)!.repeatNotKnownCards(
                      controller.notKnownCards.length.toString())),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.repeatAllCards,
                child: Text(L10n.of(context)!.repeatAllCards),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context)!.cardsLeft(controller.cards.length.toString()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CardWidget(controller),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                L10n.of(context)!.learnDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
