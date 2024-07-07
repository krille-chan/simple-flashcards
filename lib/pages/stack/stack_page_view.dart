import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/settings_keys.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/stack/stack_page.dart';

class StackPageView extends StatelessWidget {
  final StackPageController controller;
  const StackPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final name = controller.widget.stackName;
    final cardsPerSession = SimpleFlashcards.of(context)
            .preferences
            .getInt(SettingsKeys.cardsPerSessionKey) ??
        SettingsKeys.defaultCardsPerSessionKey;
    final cardsToLearn =
        controller.cards.where((card) => card.canLevelUp).length;
    final cardsToLearnInNextSession =
        min(cardsPerSession, controller.cards.length);
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        titleSpacing: 0,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            L10n.of(context)!.countCards(
              controller.cards.length.toString(),
              cardsToLearn.toString(),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: controller.editName,
          ),
          onTap: controller.editName,
        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.cards.any((c) => c.selected)) ...[
            if (controller.openAiApiKeyEnabled) ...[
              FloatingActionButton(
                heroTag: null,
                backgroundColor:
                    Theme.of(context).colorScheme.tertiaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onTertiaryContainer,
                onPressed: () => controller.startSession(SessionType.ai),
                child: const Icon(Icons.smart_toy_outlined),
              ),
              const SizedBox(width: 16),
            ],
            FloatingActionButton.extended(
              heroTag: 'start',
              onPressed: () => controller.startSession(SessionType.interrogate),
              icon: const Icon(Icons.school_outlined),
              label: Text(
                  L10n.of(context)!.startLearning(cardsToLearnInNextSession)),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              scrolledUnderElevation: 0,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              toolbarHeight: 64,
              title: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearch,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  prefixIcon: const Icon(Icons.search_outlined),
                  hintText: L10n.of(context)!.search,
                ),
              ),
            ),
            SliverList.builder(
              itemCount: controller.cards.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    child: Card(
                      elevation: 4,
                      clipBehavior: Clip.hardEdge,
                      shadowColor:
                          Theme.of(context).colorScheme.onSurface.withAlpha(64),
                      child: SizedBox(
                        height: 52,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          onPressed: controller.addFlashCard,
                          icon: const Icon(Icons.add_outlined),
                          label: Text(L10n.of(context)!.addNewFlashCard),
                        ),
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
                      elevation: 4,
                      clipBehavior: Clip.hardEdge,
                      shadowColor:
                          Theme.of(context).colorScheme.onSurface.withAlpha(64),
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
                                    : Theme.of(context).colorScheme.onSurface,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
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
                        onTap: () => controller.toggle(card.id, !card.selected),
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
          ],
        ),
      ),
    );
  }
}
