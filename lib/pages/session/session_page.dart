import 'package:flutter/material.dart';

import 'package:flip_card/flip_card_controller.dart';
import 'package:just_audio/just_audio.dart';
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
    super.key,
  });

  @override
  SessionPageController createState() => SessionPageController();
}

class SessionPageController extends State<SessionPage> {
  final List<FlashCard> cards = [];

  bool flipped = false;

  void flip() async {
    await flipCardcontroller.toggleCard();
    setState(() {
      flipped = !flipped;
    });
  }

  static const int maxCards = 10;

  final tts = TextToSpeech();

  final AudioPlayer _audioPlayer = AudioPlayer();

  final FlipCardController flipCardcontroller = FlipCardController();

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

  void cardKnown() async {
    final card = cards[0];
    if (card.canLevelUp) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level < 10 ? card.level + 1 : card.level,
      );
    }
    cards.removeAt(0);
    await _audioPlayer.setAsset(
        'assets/sounds/${cards.isEmpty ? 'finished' : 'correct'}.mp3');
    _audioPlayer.play();
    flip();
    _readFrontOnStart();
  }

  void cardNotKnown() async {
    final card = cards[0];
    if (card.level > 0) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level - 1,
      );
    }
    cards.add(cards.removeAt(0));
    flip();
    _readFrontOnStart();
  }

  void repeatAllCards() {
    setState(() {
      cards.addAll(widget.flashCards);
    });
    _readFrontOnStart();
  }

  void nextCards() => Navigator.of(context).pop<bool>(true);

  @override
  Widget build(BuildContext context) => SessionPageView(this);
}
