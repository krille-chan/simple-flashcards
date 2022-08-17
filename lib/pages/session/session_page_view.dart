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
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: DragTarget(
                        builder: (context, data, ___) => AnimatedOpacity(
                              opacity: data.isEmpty ? 0.66 : 1,
                              duration: const Duration(milliseconds: 500),
                              child: Container(width: 128),
                            ),
                        onWillAccept: (_) => true,
                        onAccept: (_) => controller.cardNotKnown()),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: DragTarget(
                      builder: (context, data, ___) => AnimatedOpacity(
                        opacity: data.isEmpty ? 0.66 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: Container(width: 128),
                      ),
                      onWillAccept: (_) => true,
                      onAccept: (_) => controller.cardKnown(),
                    ),
                  ),
                  Center(
                    child: Draggable<bool>(
                      data: true,
                      feedback: CardWidget(controller),
                      childWhenDragging: Container(),
                      axis: Axis.horizontal,
                      child: CardWidget(controller),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                L10n.of(context)!.learnDescription,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
