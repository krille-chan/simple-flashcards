import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/home/home_page.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;
  const HomePageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.stacks),
        actions: [
          IconButton(
            onPressed: controller.goToSettings,
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: controller.stacks.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(9999),
                    elevation: 1,
                    shadowColor: Colors.grey.withAlpha(64),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 128,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    L10n.of(context)!.welcomeText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: controller.createStackAction,
                    label: Text(L10n.of(context)!.stack),
                    icon: const Icon(Icons.add_outlined),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              buildDefaultDragHandles: false,
              onReorder: controller.onReorder,
              itemCount: controller.stacks.length,
              itemBuilder: (context, i) {
                final stack = controller.stacks[i];
                final emoji = stack.emoji;
                return Padding(
                  key: Key(stack.name),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                  ),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceBright,
                            child: emoji == null
                                ? const Icon(CupertinoIcons.square_stack_fill)
                                : Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              value: stack.cards.isEmpty
                                  ? 1
                                  : 1 -
                                      (stack.cards
                                              .where((card) => card.canLevelUp)
                                              .length /
                                          stack.cards.length),
                            ),
                          ),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: i,
                        child: const Icon(
                          Icons.drag_indicator_outlined,
                          size: 16,
                        ),
                      ),
                      title: Text(stack.name),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            L10n.of(context)!.countCards(
                              stack.cards.length.toString(),
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      onTap: () => controller.goToStack(stack.name),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: controller.stacks.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: controller.createStackAction,
              label: Text(L10n.of(context)!.newStack),
              icon: const Icon(Icons.add_outlined),
            ),
    );
  }
}
