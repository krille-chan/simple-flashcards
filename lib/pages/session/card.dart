import 'package:flutter/material.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/app_constants.dart';
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
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      color: Theme.of(context).colorScheme.surfaceBright,
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.record_voice_over_outlined),
                  onPressed: readFront,
                ),
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
