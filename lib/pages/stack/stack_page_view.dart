import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/stack/stack_page.dart';

class StackPageView extends StatelessWidget {
  final StackPageController controller;
  const StackPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final name = controller.widget.stackName;
    final emoji = SimpleFlashcards.of(context).getStack(name)?.emoji;
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.stack),
        actions: [
          IconButton(
            icon: Icon(Icons.adaptive.share_outlined),
            onPressed: controller.exportStack,
          ),
          IconButton(
            icon: const Icon(Icons.check_box_outlined),
            onPressed: controller.toggleAll,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.cards.any((c) => c.selected)) ...[
            if (controller.openAiApiKeyEnabled)
              FloatingActionButton(
                heroTag: null,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                onPressed: () => controller.startSession(SessionType.ai),
                child: const Icon(Icons.smart_toy_outlined),
              ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'start',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => controller.startSession(SessionType.interrogate),
              child: const Icon(Icons.school_outlined),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                child: emoji == null
                    ? const Icon(CupertinoIcons.square_stack_fill)
                    : Text(
                        emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
              ),
              title: Text(name),
              subtitle: Text(
                L10n.of(context)!.countCards(
                  controller.cards.length.toString(),
                  controller.cards
                      .where((card) => card.canLevelUp)
                      .length
                      .toString(),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: controller.editName,
              ),
              onTap: controller.editName,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearch,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  filled: true,
                  prefixIcon: const Icon(Icons.search_outlined),
                  hintText: L10n.of(context)!.search,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.cards.length + 1,
                padding: const EdgeInsets.only(bottom: 32),
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton.icon(
                          onPressed: controller.addFlashCard,
                          icon: const Icon(Icons.add_outlined),
                          label: Text(L10n.of(context)!.addNewFlashCard),
                        ),
                      ),
                    );
                  }
                  i--;
                  final card = controller.cards[i];
                  final hint = card.hint;
                  if (controller.searchTerm?.isNotEmpty == true &&
                      !(card.front
                              .toLowerCase()
                              .contains(controller.searchTerm ?? '') ||
                          card.back
                              .toLowerCase()
                              .contains(controller.searchTerm ?? ''))) {
                    return Container();
                  }
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      child: Card(
                        child: ListTile(
                          trailing: SizedBox(
                            height: 32,
                            width: 32,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: card.level / 10,
                                  color: card.selected && card.canLevelUp
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                ),
                                if (card.selected)
                                  Icon(
                                    Icons.check_circle,
                                    color: card.canLevelUp
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                              ],
                            ),
                          ),
                          onTap: () =>
                              controller.toggle(card.id, !card.selected),
                          onLongPress: () => controller.editCard(i),
                          title: Text(card.front),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Text(
                                card.back,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if (hint != null && hint.isNotEmpty)
                                Text(
                                  '${L10n.of(context)!.hint}: $hint',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
