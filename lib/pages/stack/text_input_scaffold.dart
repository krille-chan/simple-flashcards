import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'package:simple_flashcards/models/flash_card.dart';

class TextInputScaffold extends StatefulWidget {
  final FlashCard? flashCard;
  const TextInputScaffold({this.flashCard, super.key});

  @override
  State<TextInputScaffold> createState() => _TextInputScaffoldState();
}

class _TextInputScaffoldState extends State<TextInputScaffold> {
  @override
  void initState() {
    _frontController.text = widget.flashCard?.front ?? '';
    _backController.text = widget.flashCard?.back ?? '';
    _hintController.text = widget.flashCard?.hint ?? '';
    super.initState();
  }

  void cancelAction(BuildContext context) {
    Navigator.of(context).pop<FlashCard?>(null);
  }

  void saveAction(BuildContext context) {
    if (_frontController.text.isEmpty || _backController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.pleaseFillOut),
        ),
      );
      return;
    }
    Navigator.of(context).pop<FlashCard>(
      FlashCard(
        id: widget.flashCard?.id ?? 0,
        front: _frontController.text,
        back: _backController.text,
        hint: _hintController.text.isEmpty ? '' : _hintController.text,
        selected: true,
        level: widget.flashCard?.level ?? 0,
        lastLevelUp: widget.flashCard?.lastLevelUp,
      ),
    );
  }

  final TextEditingController _frontController = TextEditingController();

  final TextEditingController _backController = TextEditingController();

  final TextEditingController _hintController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () => cancelAction(context),
        ),
        title: Text(
          widget.flashCard == null
              ? L10n.of(context)!.addNewFlashCard
              : L10n.of(context)!.editFlashCard,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(spacing),
          child: Column(
            children: [
              _FlashCardTextField(
                controller: _frontController,
                hintText: L10n.of(context)!.front,
              ),
              const SizedBox(height: spacing),
              _FlashCardTextField(
                controller: _backController,
                hintText: L10n.of(context)!.back,
              ),
              const SizedBox(height: spacing),
              TextField(
                controller: _hintController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: L10n.of(context)!.hint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: spacing),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_outlined),
                label: Text(L10n.of(context)!.save),
                onPressed: () => saveAction(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashCardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const _FlashCardTextField({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        expands: true,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
