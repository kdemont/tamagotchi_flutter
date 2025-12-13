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

class WakeUp extends HomeEvent {
  const WakeUp();
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
  const RubPoop();
}

class ExitCleaning extends HomeEvent {
  const ExitCleaning();
}

class ResetPoopCount extends HomeEvent {
  const ResetPoopCount();
}

class UpdateSteps extends HomeEvent {
  final int stepCount;

  const UpdateSteps(this.stepCount);

  @override
  List<Object?> get props => [stepCount];
}

class Pet extends HomeEvent {
  const Pet();
}

class Dead extends HomeEvent {
  final Tamagotchi tamagotchi;
  const Dead(this.tamagotchi);

  @override
  List<Object?> get props => [tamagotchi];
}

class CreateNewTamagotchi extends HomeEvent {
  final String name;
  const CreateNewTamagotchi(this.name);

  @override
  List<Object?> get props => [name];
}
