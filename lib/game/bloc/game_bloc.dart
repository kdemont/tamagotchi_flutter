import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tamagotchi_flutter/gen/strings.g.dart';

import '../../home/bloc/home_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final HomeBloc homeBloc;
  static const int maxAttempts = 10;
  static const int minNumber = 1;
  static const int maxNumber = 100;

  GameBloc({required this.homeBloc}) : super(const GameRules()) {
    on<StartGame>(_onStartGame);
    on<MakeGuess>(_onMakeGuess);
    on<RestartGame>(_onRestartGame);
    on<ReturnHome>(_onReturnHome);
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    final random = Random();
    final targetNumber = random.nextInt(maxNumber - minNumber + 1) + minNumber;

    emit(
      GamePlaying(
        targetNumber: targetNumber,
        attemptsRemaining: maxAttempts,
        score: 0,
      ),
    );
  }

  void _onMakeGuess(MakeGuess event, Emitter<GameState> emit) {
    if (state is! GamePlaying) return;

    final currentState = state as GamePlaying;
    final guess = event.guess;
    final newAttempts = currentState.attemptsRemaining - 1;
    final newPreviousGuesses = [...currentState.previousGuesses, guess];

    if (guess == currentState.targetNumber) {
      // Win! Increase happiness
      final finalScore = currentState.score + (newAttempts * 10) + 100;
      homeBloc.add(const Play());
      emit(GameWon(finalScore: finalScore));
    } else if (newAttempts <= 0) {
      // Lost! The tamagotchi will naturally be sad as happiness decays
      // No specific action needed - the player's loss doesn't require an event
      emit(
        GameLost(
          targetNumber: currentState.targetNumber,
          finalScore: currentState.score,
        ),
      );
    } else {
      // Continue playing
      String hint;
      bool isHigher;
      if (guess < currentState.targetNumber) {
        hint = t.game.hints.higher;
        isHigher = true;
      } else {
        hint = t.game.hints.lower;
        isHigher = false;
      }

      final newScore = currentState.score + 5; // Points for trying

      emit(
        currentState.copyWith(
          attemptsRemaining: newAttempts,
          score: newScore,
          hint: hint,
          isHigher: isHigher,
          previousGuesses: newPreviousGuesses,
        ),
      );
    }
  }

  void _onRestartGame(RestartGame event, Emitter<GameState> emit) {
    final random = Random();
    final targetNumber = random.nextInt(maxNumber - minNumber + 1) + minNumber;

    emit(
      GamePlaying(
        targetNumber: targetNumber,
        attemptsRemaining: maxAttempts,
        score: 0,
      ),
    );
  }

  void _onReturnHome(ReturnHome event, Emitter<GameState> emit) {
    emit(const GameRules());
  }
}
