import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

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

  final TextEditingController anserTextController = TextEditingController();
  final FocusNode answerFocusNode = FocusNode();

  static const int maxCards = 10;

  bool isLoadingNextCard = false;

  final tts = FlutterTts();

  bool wrongTypeAnswer = false;

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

  bool get typeAnswer =>
      SimpleFlashcards.of(context)
          .preferences
          .getBool(SettingsKeys.typeAnswer) ??
      false;

  void checkTypeAnswer() {
    final input = anserTextController.text
        .trim()
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('\n', '');
    final correctAnswer = cards[0]
        .back
        .trim()
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('\n', '');
    if (input != correctAnswer) {
      setState(() {
        wrongTypeAnswer = true;
      });
      return;
    }

    cardKnown();
  }

  void cardKnown() async {
    final card = cards[0];
    if (card.canLevelUp) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level + 1,
      );
    }

    setState(() {
      isLoadingNextCard = true;
    });

    if (flipCardcontroller.state?.isFront == true) {
      flipCardcontroller.toggleCard();
    }

    _playSound(true);
    Confetti.launch(
      context,
      options: ConfettiOptions(
        particleCount: card.level * 16,
        spread: Random().nextInt(80).toDouble() + 20,
      ),
    );
    await Future.delayed(const Duration(seconds: 2));

    if (flipCardcontroller.state?.isFront != true) {
      flipCardcontroller.toggleCardWithoutAnimation();
    }
    setState(() {
      isLoadingNextCard = false;
      cards.removeAt(0);
      wrongTypeAnswer = false;
      anserTextController.clear();
    });
    if (!mounted) return;
    _readFrontOnStart();
  }

  void _playSound([bool success = true]) async {
    try {
      await _audioPlayer.setAsset(
          'assets/sounds/${cards.length <= 1 && success ? 'finished' : !success ? 'skip' : 'correct'}.mp3');
      await _audioPlayer.play();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  void cardNotKnown() async {
    final card = cards[0];
    if (card.level > 0) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        1,
      );
    }

    setState(() {
      isLoadingNextCard = true;
    });
    _playSound(false);

    if (flipCardcontroller.state?.isFront == true) {
      flipCardcontroller.toggleCard();
    }
    await Future.delayed(const Duration(seconds: 2));
    if (flipCardcontroller.state?.isFront == false) {
      flipCardcontroller.toggleCardWithoutAnimation();
    }

    setState(() {
      isLoadingNextCard = false;
      cards.add(cards.removeAt(0));
      wrongTypeAnswer = false;
      anserTextController.clear();
    });
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
