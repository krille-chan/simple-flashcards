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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: const Center(child: BackButton()),
        titleSpacing: 0,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              L10n.of(context)!.countCards(
                controller.cards.length.toString(),
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<PopupMenuStackAction>(
            onSelected: controller.onPopupMenuStackAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: PopupMenuStackAction.selectAll,
                child: Row(
                  children: [
                    const Icon(Icons.check_box_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.selectAll),
                  ],
                ),
              ),
              PopupMenuItem(
                value: PopupMenuStackAction.edit,
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.editStack),
                  ],
                ),
              ),
              PopupMenuItem(
                value: PopupMenuStackAction.export,
                child: Row(
                  children: [
                    const Icon(Icons.download_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.export),
                  ],
                ),
              ),
              PopupMenuItem(
                value: PopupMenuStackAction.delete,
                child: Row(
                  children: [
                    const Icon(Icons.delete_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.deleteStack),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(9999),
                      clipBehavior: Clip.hardEdge,
                      color: Theme.of(context).colorScheme.surfaceBright,
                      child: SizedBox(
                        width: 128,
                        height: 128,
                        child: Center(
                          child: Text(
                            SimpleFlashcards.of(context)
                                    .getStack(controller.widget.stackName)
                                    ?.emoji ??
                                name.substring(0, 1),
                            style: const TextStyle(fontSize: 64),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: controller.editEmoji,
                        child: const Icon(Icons.edit_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  elevation: 0,
                  heroTag: null,
                  onPressed: () => controller.addFlashCard(),
                  icon: const Icon(Icons.add_outlined),
                  label: Text(L10n.of(context)!.card),
                ),
                const SizedBox(width: 16),
                if (controller.cards.any((c) => c.selected)) ...[
                  FloatingActionButton.extended(
                    elevation: 0,
                    heroTag: null,
                    onPressed: () =>
                        controller.startSession(SessionType.interrogate),
                    icon: const Icon(Icons.school_outlined),
                    label: Text(L10n.of(context)!.learn),
                  ),
                  if (controller.openAiApiKeyEnabled) ...[
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      elevation: 0,
                      heroTag: null,
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                      onPressed: () => controller.startSession(SessionType.ai),
                      child: const Icon(Icons.smart_toy_outlined),
                    ),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 16.0),
            Divider(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              height: 1,
            ),
            Expanded(
              child: Material(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      floating: true,
                      scrolledUnderElevation: 0,
                      elevation: 0,
                      toolbarHeight: 84,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      title: Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: controller.onSearch,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(90),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            prefixIcon: const Icon(Icons.search_outlined),
                            hintText: L10n.of(context)!.search,
                          ),
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: controller.cards.length,
                      itemBuilder: (_, i) {
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
                              elevation: 0,
                              clipBehavior: Clip.hardEdge,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              child: ListTile(
                                trailing: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: card.level / 14,
                                        color: card.selected && card.canLevelUp
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                      if (card.selected)
                                        Icon(
                                          Icons.check_circle,
                                          color: card.canLevelUp
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    if (hint != null && hint.isNotEmpty)
                                      Text(
                                        '${L10n.of(context)!.hint}: $hint',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
            ),
          ],
        ),
      ),
    );
  }
}
