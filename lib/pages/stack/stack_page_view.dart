import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/stack/stack_page.dart';
import 'package:simple_flashcards/utils/string_color.dart';

class StackPageView extends StatelessWidget {
  final StackPageController controller;
  const StackPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = controller.widget.stackName;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.delete),
            onPressed: controller.deleteStackAction,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.school_outlined),
        onPressed: controller.cards.isEmpty ? null : controller.startSession,
        label: Text(L10n.of(context)!.startLearning),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: name.color,
              child: const Icon(
                CupertinoIcons.square_stack_fill,
                color: Colors.white,
              ),
            ),
            title: Text(name),
            subtitle: Text(
              L10n.of(context)!.countCards(controller.cards.length.toString()),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: controller.editName,
            ),
            onTap: controller.editName,
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 2,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(16),
                  child: ListView.builder(
                    itemCount: controller.cards.length + 1,
                    padding: const EdgeInsets.only(bottom: 32, top: 8),
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.onBackground,
                            child: Icon(
                              Icons.add_outlined,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          title: Text(
                            L10n.of(context)!.addNewFlashCard,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          onTap: controller.addFlashCard,
                        );
                      }
                      i--;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.doc_append,
                            color: Theme.of(context).textTheme.subtitle1?.color,
                          ),
                        ),
                        title: Text(controller.cards[i].front),
                        subtitle: Text(controller.cards[i].back),
                        onTap: () => controller.editCard(i),
                      );
                    },
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
