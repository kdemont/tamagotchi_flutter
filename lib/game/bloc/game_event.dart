part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {
  const StartGame();
}

class MakeGuess extends GameEvent {
  final int guess;

  const MakeGuess(this.guess);

  @override
  List<Object?> get props => [guess];
}

class RestartGame extends GameEvent {
  const RestartGame();
}

class ReturnHome extends GameEvent {
  const ReturnHome();
}
