import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'package:simple_flashcards/pages/session/card.dart';
import 'package:simple_flashcards/pages/session/session_page.dart';

class SessionPageView extends StatelessWidget {
  final SessionPageController controller;
  const SessionPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    const spacing = 20.0;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(controller.widget.stackName),
          subtitle: Text(
            controller.cards.isEmpty
                ? L10n.of(context)!.allCardsFinished
                : L10n.of(context)!.cardsLeft(
                    controller.cards.length.toString(),
                  ),
            style: theme.textTheme.labelSmall,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.toggleSoundEffects,
            icon: Icon(
              controller.soundEffects
                  ? Icons.volume_up_outlined
                  : Icons.volume_off_outlined,
            ),
          )
        ],
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      body: SafeArea(
        child: controller.cards.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(spacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🎉',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: spacing),
                    ElevatedButton(
                      onPressed: controller.isLoadingNextCard
                          ? null
                          : controller.repeatAllCards,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Text(L10n.of(context)!.repeatAllCards),
                    ),
                    const SizedBox(height: spacing),
                    ElevatedButton(
                      onPressed: controller.isLoadingNextCard
                          ? null
                          : controller.nextCards,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Text(L10n.of(context)!.nextCards),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(spacing),
                      child: CardWidget(controller),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: spacing),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LinearProgressIndicator(
                          value: controller.cards.first.level / 14,
                          minHeight: 16,
                          borderRadius: BorderRadius.circular(16),
                          color: theme.colorScheme.tertiary,
                          backgroundColor: theme.colorScheme.tertiaryContainer,
                        ),
                        Text(
                          'Level: ${controller.cards.first.level}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: spacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: spacing),
                    child: ElevatedButton(
                      onPressed: controller.isLoadingNextCard
                          ? null
                          : controller.cardNotKnown,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Text(L10n.of(context)!.repeat),
                    ),
                  ),
                  if (controller.typeAnswer)
                    Padding(
                      padding: const EdgeInsets.all(spacing),
                      child: TextField(
                        readOnly: controller.isLoadingNextCard,
                        maxLines: 1,
                        focusNode: controller.answerFocusNode,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          controller.answerFocusNode.requestFocus();
                          controller.checkTypeAnswer();
                        },
                        controller: controller.anserTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90),
                            borderSide: controller.wrongTypeAnswer
                                ? const BorderSide(width: 1)
                                : BorderSide.none,
                          ),
                          hintText: L10n.of(context)!.typeAnswer,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceBright,
                          error: controller.wrongTypeAnswer
                              ? const SizedBox.shrink()
                              : null,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send_outlined),
                            onPressed: controller.checkTypeAnswer,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(spacing),
                      child: ElevatedButton(
                        onPressed: controller.isLoadingNextCard
                            ? null
                            : controller.cardKnown,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: Text(L10n.of(context)!.known),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
