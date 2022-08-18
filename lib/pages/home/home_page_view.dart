import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/home/home_page.dart';

class HomePageView extends StatelessWidget {
  final HomePageController controller;
  const HomePageView(this.controller, {Key? key}) : super(key: key);

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
                  const Opacity(
                    opacity: 0.33,
                    child: Icon(
                      CupertinoIcons.square_stack,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    L10n.of(context)!.welcomeText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              onReorder: controller.onReorder,
              itemCount: controller.stacks.length,
              itemBuilder: (context, i) {
                final stack = controller.stacks[i];
                final emoji = stack.emoji;
                return ListTile(
                  key: Key(stack.name),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    child: emoji == null
                        ? const Icon(CupertinoIcons.square_stack_fill)
                        : Text(
                            emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                  ),
                  title: Text(stack.name),
                  subtitle: Text(
                    L10n.of(context)!.countCards(stack.cards.length.toString()),
                  ),
                  onTap: () => controller.goToStack(stack.name),
                  onLongPress: () => controller.stackContextMenu(stack.name),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createStackAction,
        label: Text(L10n.of(context)!.newStack),
        icon: const Icon(Icons.add_outlined),
      ),
    );
  }
}
