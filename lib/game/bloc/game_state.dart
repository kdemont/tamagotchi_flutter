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
  final List<int> previousGuesses;

  const GamePlaying({
    required this.targetNumber,
    required this.attemptsRemaining,
    required this.score,
    this.hint,
    this.previousGuesses = const [],
  });

  @override
  List<Object?> get props => [
        targetNumber,
        attemptsRemaining,
        score,
        hint,
        previousGuesses,
      ];

  GamePlaying copyWith({
    int? targetNumber,
    int? attemptsRemaining,
    int? score,
    String? hint,
    List<int>? previousGuesses,
  }) {
    return GamePlaying(
      targetNumber: targetNumber ?? this.targetNumber,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      score: score ?? this.score,
      hint: hint ?? this.hint,
      previousGuesses: previousGuesses ?? this.previousGuesses,
    );
  }
}

class GameWon extends GameState {
  final int finalScore;

  const GameWon({required this.finalScore});

  @override
  List<Object?> get props => [finalScore];
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
