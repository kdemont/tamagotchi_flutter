part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameRules extends GameState {
  const GameRules();
}

class GamePlaying extends GameState {
  final int targetNumber;
  final int attemptsRemaining;
  final int score;
  final String? hint;
  final bool? isHigher; // true if should go higher, false if lower, null if no hint yet
  final List<int> previousGuesses;

  const GamePlaying({
    required this.targetNumber,
    required this.attemptsRemaining,
    required this.score,
    this.hint,
    this.isHigher,
    this.previousGuesses = const [],
  });

  @override
  List<Object?> get props => [
        targetNumber,
        attemptsRemaining,
        score,
        hint,
        isHigher,
        previousGuesses,
      ];

  GamePlaying copyWith({
    int? targetNumber,
    int? attemptsRemaining,
    int? score,
    String? hint,
    bool? isHigher,
    List<int>? previousGuesses,
  }) {
    return GamePlaying(
      targetNumber: targetNumber ?? this.targetNumber,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      score: score ?? this.score,
      hint: hint ?? this.hint,
      isHigher: isHigher ?? this.isHigher,
      previousGuesses: previousGuesses ?? this.previousGuesses,
    );
  }
}

class GameWon extends GameState {
  final int finalScore;
  final int attemptsUsed;

  const GameWon({
    required this.finalScore,
    required this.attemptsUsed,
  });

  @override
  List<Object?> get props => [finalScore, attemptsUsed];
}

class GameLost extends GameState {
  final int targetNumber;
  final int finalScore;

  const GameLost({
    required this.targetNumber,
    required this.finalScore,
  });

  @override
  List<Object?> get props => [targetNumber, finalScore];
}
