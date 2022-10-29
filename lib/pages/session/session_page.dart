import 'package:flutter/material.dart';

import 'package:text_to_speech/text_to_speech.dart';

import 'package:simple_flashcards/config/settings_keys.dart';
import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/session/session_page_view.dart';

class SessionPage extends StatefulWidget {
  final String stackName;
  final List<FlashCard> flashCards;
  const SessionPage({
    required this.flashCards,
    required this.stackName,
    Key? key,
  }) : super(key: key);

  @override
  SessionPageController createState() => SessionPageController();
}

class SessionPageController extends State<SessionPage> {
  final List<FlashCard> cards = [];
  final List<FlashCard> notKnownCards = [];

  bool flipped = false;

  void flip() => setState(() => flipped = !flipped);

  static const int maxCards = 10;

  final tts = TextToSpeech();

  void _readFrontOnStart() {
    if (SimpleFlashcards.of(context)
                .preferences
                .getBool(SettingsKeys.enableTextToSpeechKey) !=
            true ||
        cards.isEmpty) {
      return;
    }
    readFront();
  }

  void readFront() {
    final lang = SimpleFlashcards.of(context)
        .preferences
        .getString(SettingsKeys.textToSpeechLanguageKey);
    if (lang != null) tts.setLanguage(lang);
    tts.speak(cards.first.front);
  }

  @override
  void initState() {
    super.initState();
    cards.addAll(widget.flashCards);
    _readFrontOnStart();
  }

  void cardKnown() {
    final card = cards[0];
    if (card.canLevelUp && card.level < 10) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level + 1,
      );
    }
    setState(() {
      cards.removeAt(0);
      flipped = false;
    });
    _readFrontOnStart();
  }

  void cardNotKnown() {
    final card = cards[0];
    if (card.level > 0) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level - 1,
      );
    }
    setState(() {
      notKnownCards.add(cards.removeAt(0));
      flipped = false;
    });
    _readFrontOnStart();
  }

  void repeatAllCards() {
    setState(() {
      cards.addAll(widget.flashCards);
    });
    _readFrontOnStart();
  }

  void repeatNotKnownCards() {
    setState(() {
      cards.addAll(notKnownCards);
      notKnownCards.clear();
    });
    _readFrontOnStart();
  }

  @override
  Widget build(BuildContext context) => SessionPageView(this);
}
