import 'package:flutter/material.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/session/session_page.dart';

class CardWidget extends StatelessWidget {
  final SessionPageController controller;
  const CardWidget(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
        maxHeight: 600,
      ),
      child: FlipCard(
        controller: controller.flipCardcontroller,
        side: controller.flipped ? CardSide.BACK : CardSide.FRONT,
        front: FlashCardWidget(
          data: controller.cards.first.front,
          title: L10n.of(context)!.front,
          readFront: controller.readFront,
        ),
        back: FlashCardWidget(
          data: controller.cards.first.back,
          title: L10n.of(context)!.back,
          readFront: controller.readFront,
        ),
      ),
    );
  }
}

class FlashCardWidget extends StatelessWidget {
  final String data;
  final String title;
  final void Function() readFront;
  const FlashCardWidget(
      {required this.data,
      required this.title,
      required this.readFront,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.volume_up_outlined),
                onPressed: readFront,
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: SelectableText(
                    data,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
