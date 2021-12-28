import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/home/home_page.dart';
import 'package:simple_flashcards/utils/string_color.dart';
import 'package:yaru_icons/yaru_icons.dart';

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
            icon: const Icon(YaruIcons.settings),
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
              itemBuilder: (context, i) => ListTile(
                key: Key(controller.stacks[i].name),
                leading: CircleAvatar(
                  backgroundColor: controller.stacks[i].name.color,
                  child: const Icon(
                    CupertinoIcons.square_stack_fill,
                    color: Colors.white,
                  ),
                ),
                title: Text(controller.stacks[i].name),
                subtitle: Text(
                  L10n.of(context)!
                      .countCards(controller.stacks[i].cards.length.toString()),
                ),
                onTap: () => controller.goToStack(controller.stacks[i].name),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createStackAction,
        label: Text(L10n.of(context)!.newStack),
        icon: const Icon(YaruIcons.plus),
      ),
    );
  }
}
