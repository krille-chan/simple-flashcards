import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/stack/edit_stack_input.dart';

class StackEditBottomSheet extends StatefulWidget {
  final String currentName;
  const StackEditBottomSheet({required this.currentName, Key? key})
      : super(key: key);

  @override
  State<StackEditBottomSheet> createState() => _StackEditBottomSheetState();
}

class _StackEditBottomSheetState extends State<StackEditBottomSheet> {
  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentName);
    super.initState();
  }

  late final TextEditingController _nameController;
  String? _nameError;
  String? _emoji;

  void _save() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = L10n.of(context)!.pleaseFillOut;
      });
      return;
    }
    Navigator.of(context).pop<EditStackInput>(
      EditStackInput(
        name: _nameController.text,
        emoji: _emoji,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emoji = _emoji;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: Navigator.of(context).pop,
        ),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(L10n.of(context)!.save),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              prefixIcon: emoji == null
                  ? null
                  : Container(
                      alignment: Alignment.center,
                      width: 32,
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
              errorText: _nameError,
            ),
          ),
          Expanded(
            child: EmojiPicker(
              onEmojiSelected: (_, e) => setState(
                () {
                  _emoji = e.emoji;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
