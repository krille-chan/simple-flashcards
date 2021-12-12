import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/session/session_page.dart';

class CardWidget extends StatelessWidget {
  final SessionPageController controller;
  const CardWidget(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
      ),
      child: Material(
        elevation: 10,
        child: InkWell(
          onTap: controller.flip,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                title: Text(
                  controller.flipped
                      ? L10n.of(context)!.back
                      : L10n.of(context)!.front,
                ),
              ),
              Expanded(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.flipped
                        ? controller.cards.first.back
                        : controller.cards.first.front,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
