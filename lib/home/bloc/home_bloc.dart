import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/tamagotchi.dart';
import '../../repository/tamagotchi_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TamagotchiRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadTamagotchi>(_onLoad);
    on<Feed>(_onFeed);
    on<Play>(_onPlay);
    on<Sleep>(_onSleep);
    on<Clean>(_onClean);
    on<Tick>(_onTick);
  }

  Future<void> _onLoad(LoadTamagotchi event, Emitter<HomeState> emit) async {
    final tama = await repository.getTamagotchi();
    emit(HomeLoaded(tamagotchi: tama));
  }

  void _onFeed(Feed event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      final updated = current.copyWith(
        hunger: (current.hunger + 15).clamp(0, 100),
        happiness: (current.happiness + 5).clamp(0, 100),
      );
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onPlay(Play event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      final updated = current.copyWith(
        happiness: (current.happiness + 15).clamp(0, 100),
        energy: (current.energy - 10).clamp(0, 100),
      );
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onSleep(Sleep event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      final updated = current.copyWith(
        energy: (current.energy + 30).clamp(0, 100),
        age: current.age + 1,
      );
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onClean(Clean event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      final updated = current.copyWith(cleanliness: 100);
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onTick(Tick event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      final updated = current.copyWith(
        hunger: (current.hunger - 1).clamp(0, 100),
        energy: (current.energy - 1).clamp(0, 100),
        happiness: (current.happiness - 1).clamp(0, 100),
        cleanliness: (current.cleanliness - 1).clamp(0, 100),
      );
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }
}
