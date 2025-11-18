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

class TamagotchiUpdated extends HomeEvent {
  final Tamagotchi tamagotchi;

  const TamagotchiUpdated(this.tamagotchi);

  @override
  List<Object?> get props => [tamagotchi];
}
