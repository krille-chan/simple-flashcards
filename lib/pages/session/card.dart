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
        maxHeight: 600,
      ),
      child: Material(
        elevation: 10,
        shadowColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              title: Text(
                controller.flipped
                    ? L10n.of(context)!.back
                    : L10n.of(context)!.front,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.volume_up_outlined),
                  onPressed: controller.readFront,
                ),
              ],
            ),
            Expanded(
              child: InkWell(
                onTap: controller.flip,
                onLongPress: controller.flip,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(shrinkWrap: true, children: [
                      SelectableText(
                        controller.flipped
                            ? controller.cards.first.back
                            : controller.cards.first.front,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: controller.cardNotKnown,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    L10n.of(context)!.notKnown,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: controller.cardKnown,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    L10n.of(context)!.known,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
