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
        side: CardSide.FRONT,
        front: FlashCardWidget(
          data: controller.cards.first.front,
          title: L10n.of(context)!.front,
          readFront: controller.readFront,
        ),
        back: FlashCardWidget(
          data: controller.cards.first.back,
          hint: controller.cards.first.hint,
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
  final String? hint;
  final void Function() readFront;
  const FlashCardWidget(
      {required this.data,
      required this.title,
      required this.readFront,
      this.hint,
      super.key});

  @override
  Widget build(BuildContext context) {
    final hint = this.hint;
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          )),
      shadowColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SelectableText(
                      data,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: data.length < 16
                              ? 50
                              : data.length > 64
                                  ? 24
                                  : 32),
                    ),
                    if (hint != null && hint.isNotEmpty) ...[
                      const Divider(),
                      SelectableText(
                        hint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
