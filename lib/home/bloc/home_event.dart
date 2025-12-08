part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTamagotchi extends HomeEvent {
  const LoadTamagotchi();
}

class Feed extends HomeEvent {
  const Feed();
}

class Play extends HomeEvent {
  const Play();
}

class Sleep extends HomeEvent {
  const Sleep();
}

class Clean extends HomeEvent {
  const Clean();
}

class Tick extends HomeEvent {
  const Tick();
}

class LiceAttack extends HomeEvent {
  const LiceAttack();
}

class ClearLice extends HomeEvent {
  const ClearLice();
}

class NonRepeatingEventComplete extends HomeEvent {
  const NonRepeatingEventComplete();
}

class PoopEvent extends HomeEvent {
  const PoopEvent();
}

class StartCleaning extends HomeEvent {
  const StartCleaning();
}

class RubPoop extends HomeEvent {
  final int poopIndex; // 0, 1, or 2 for the three positions

  const RubPoop(this.poopIndex);

  @override
  List<Object?> get props => [poopIndex];
}

class ExitCleaning extends HomeEvent {
  const ExitCleaning();
}
