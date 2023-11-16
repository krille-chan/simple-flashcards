import 'package:flutter/material.dart';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/ai_session/ai_session_page.dart';

class AiSessionPageView extends StatelessWidget {
  final AiSessionPageController controller;
  const AiSessionPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final messages = controller.messages.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.aiChatBot),
      ),
      body: Column(
        children: [
          Expanded(
            child: SelectionArea(
              child: ListView.builder(
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: messages[i].role == Role.assistant
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (messages[i].role == Role.assistant)
                        const CircleAvatar(
                            child: Icon(Icons.smart_toy_outlined)),
                      BubbleSpecialThree(
                        text: messages[i].content ?? '-',
                        color: messages[i].role == Role.assistant
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.primary,
                        isSender: messages[i].role == Role.user,
                        tail: true,
                        textStyle: TextStyle(
                          color: messages[i].role == Role.assistant
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (controller.botIsTyping)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.smart_toy_outlined),
                        CircularProgressIndicator(strokeWidth: 2),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<int>(
                      valueListenable: controller.animationTick,
                      builder: (context, tick, _) {
                        return BubbleSpecialThree(
                          text: '.' * tick + ' ' * (4 - tick),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          isSender: false,
                          tail: true,
                          textStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 16,
                          ),
                        );
                      }),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller.textEditingController,
              onSubmitted:
                  controller.botIsTyping ? null : controller.generateAiMessage,
              autofocus: true,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                filled: true,
                border: const UnderlineInputBorder(),
                hintText: L10n.of(context)!.yourAnswer,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: controller.botIsTyping
                      ? null
                      : () => controller.generateAiMessage(
                            controller.textEditingController.text,
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
