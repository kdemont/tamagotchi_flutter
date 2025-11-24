import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/tamagotchi.dart';
import '../../models/visual_state.dart';
import '../../repository/tamagotchi_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TamagotchiRepository repository;
  // Interval between ticks. Adjust to production value (e.g. 60 seconds).
  static const Duration tickInterval = Duration(seconds: 2);

  Timer? _ticker;
  // optional counter for batching saves (unused for now)
  // int _unsavedTickCounter = 0;
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadTamagotchi>(_onLoad);
    on<Feed>(_onFeed);
    on<Play>(_onPlay);
    on<Sleep>(_onSleep);
    on<Clean>(_onClean);
    on<Tick>(_onTick);
    on<LiceAttack>(_onLiceAttack);
    on<ClearLice>(_onClearLice);
    _startTicker();
  }

  void _startTicker({Duration? interval}) {
    final dur = interval ?? tickInterval;
    _ticker?.cancel();
    _ticker = Timer.periodic(dur, (_) => add(const Tick()));
  }

  void _listenAccelerometer(){
    // Placeholder for accelerometer-based tick acceleration logic.
    // In a real app, this would interface with device sensors.
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }

  Future<void> _onLoad(LoadTamagotchi event, Emitter<HomeState> emit) async {
    final tama = await repository.getTamagotchi();

    // Apply ticks that occurred while the app was closed/backgrounded
    final lastSaved = await repository.getLastSavedTime();
    if (lastSaved != null) {
      final now = DateTime.now();
      final elapsed = now.difference(lastSaved);
      final ticks = elapsed.inSeconds ~/ tickInterval.inSeconds;
      if (ticks > 0) {
        final updated = tama.copyWith(
          hunger: (tama.hunger - ticks).clamp(0, 100),
          energy: (tama.energy - ticks).clamp(0, 100),
          happiness: (tama.happiness - ticks).clamp(0, 100),
          cleanliness: (tama.cleanliness - ticks).clamp(0, 100),
        );
        await repository.saveTamagotchi(updated);
        emit(HomeLoaded(tamagotchi: updated));
        return;
      }
    }

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

  void _onLiceAttack(LiceAttack event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      if (current.state != VisualState.liceAttack) return; // already infested
      final updated = current.copyWith(state: VisualState.liceAttack);
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onClearLice(ClearLice event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      if (current.state != VisualState.liceAttack) return;
      final updated = current.copyWith(
        state: VisualState.idle,
        cleanliness: (current.cleanliness - 10).clamp(0, 100),
      );
      // clearing lice slightly reduces cleanliness
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onTick(Tick event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      // small chance to trigger lice attack when not already infested
      if (current.state != VisualState.liceAttack) {
        final rng = Random();
        // e.g. 0.5% chance per tick
        if (rng.nextDouble() < 0.005) {
          add(const LiceAttack());
        }
      }
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
