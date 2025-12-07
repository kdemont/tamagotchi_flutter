import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/tamagotchi.dart';
import '../../models/visual_state.dart';
import '../../repository/tamagotchi_repository.dart';
import '../../utils/constants.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TamagotchiRepository repository;
  // Interval between ticks. Adjust to production value (e.g. 60 seconds).
  static const Duration tickInterval = Duration(seconds: 1);

  // Constants for shake detection
  final double gThreshold = 2.5; // g-force threshold for shake detection
  final int windowMs = 3000;
  final int requiredCount = 10;

  final Random _random = Random();

  StreamSubscription<AccelerometerEvent>? _sub;
  final List<int> _timestamps = [];

  void startAccelerometer() {
    if (_sub != null) return;
    _sub = accelerometerEventStream().listen(_onAccel);
  }

  void stopAccelerometer() {
    _sub?.cancel();
    _sub = null;
    _timestamps.clear();
  }

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
    on<NonRepeatingEventComplete>(_onNonRepeatingEventComplete);
    _startTicker();
  }

  void _startTicker({Duration? interval}) {
    final dur = interval ?? tickInterval;
    _ticker?.cancel();
    _ticker = Timer.periodic(dur, (_) => add(const Tick()));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    stopAccelerometer();
    return super.close();
  }

  Future<void> _onLoad(LoadTamagotchi event, Emitter<HomeState> emit) async {
    final tama = await repository.getTamagotchi();

    // Apply ticks that occurred while the app was closed/backgrounded
    final now = DateTime.now();
    final elapsed = now.difference(tama.lastUpdateTime);
    final ticks = elapsed.inSeconds ~/ tickInterval.inSeconds;
    if (ticks > 0) {
      final updated = tama.copyWith(
        hunger: (tama.hunger - ticks).clamp(0, 100),
        energy: (tama.energy - ticks).clamp(0, 100),
        happiness: (tama.happiness - ticks).clamp(0, 100),
        cleanliness: (tama.cleanliness - ticks).clamp(0, 100),
        lastUpdateTime: now,
      );
      await repository.saveTamagotchi(updated);
      // if after applying elapsed ticks the tama is infested, start accelerometer
      if (updated.state == VisualState.liceAttack) {
        startAccelerometer();
      }
      emit(HomeLoaded(tamagotchi: updated));
      return;
    }

    // Emit loaded tama and start accelerometer if needed
    emit(HomeLoaded(tamagotchi: tama));
    if (tama.state == VisualState.liceAttack) {
      startAccelerometer();
    }
  }

  void _onFeed(Feed event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      final updated = current.copyWith(
        hunger: (current.hunger + 15).clamp(0, 100),
        happiness: (current.happiness + 5).clamp(0, 100),
        lastUpdateTime: DateTime.now(),
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
        lastUpdateTime: DateTime.now(),
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
        lastUpdateTime: DateTime.now(),
      );
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onClean(Clean event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;

      if (VisualState.canInterrupt(current.state, VisualState.cleaning)) {
        final newCleanliness = (current.cleanliness + 30).clamp(0, 100);
        final updated = current.copyWith(
          cleanliness: newCleanliness,
          state: VisualState.cleaning,
          lastUpdateTime: DateTime.now(),
        );
        repository.saveTamagotchi(updated);
        emit(HomeLoaded(tamagotchi: updated));
      } else {
        return; // cannot interrupt current state
      }
    }
  }

  Future<void> _onLiceAttack(LiceAttack event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;

      if (current.state == VisualState.liceAttack) return; // already infested

      startAccelerometer();

      final updated = current.copyWith(
        state: VisualState.liceAttack,
        lastUpdateTime: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  Future<void> _onClearLice(ClearLice event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      if (current.state != VisualState.liceAttack) return;

      stopAccelerometer();

      final updated = current.copyWith(
        state: VisualState.idle,
        cleanliness: (current.cleanliness + 20).clamp(0, 100),
        lastUpdateTime: DateTime.now(),
      );
      // clearing lice slightly reduces cleanliness
      await repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  Future<void> _onNonRepeatingEventComplete(
    NonRepeatingEventComplete event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;

      final updated = current.copyWith(
        state: VisualState.idle,
        lastUpdateTime: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onTick(Tick event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;
      // small chance to trigger lice attack when not already infested
      if (current.state != VisualState.liceAttack) {
        double liceChance = 0.05; // base 5% per tick
        if (current.cleanliness < 30) {
          liceChance += 0.2; // +20% if dirty
        }

        // e.g. 0.5% chance per tick
        if (_random.nextDouble() < liceChance) {
          print('[TamagotchiBloc] Lice Attack triggered by tick');
          add(const LiceAttack());
        }
      }

      final newHunger = (current.hunger - 2).clamp(0, 100);
      print('[TamagotchiService] Hunger: ${current.hunger} -> $newHunger');

      final newEnergy = (current.energy - 1).clamp(0, 100);
      print('[TamagotchiService] Energy: ${current.energy} -> $newEnergy');

      int newHappiness;
      if (current.hunger < 30 || current.energy < 30) {
        newHappiness = (current.happiness - 2).clamp(0, 100);
        print(
          '[TamagotchiService] Happiness: ${current.happiness} -> $newHappiness (low stats penalty)',
        );
      } else {
        newHappiness = (current.happiness - 1).clamp(0, 100);
        print(
          '[TamagotchiService] Happiness: ${current.happiness} -> $newHappiness',
        );
      }

      var newCleanliness = current.cleanliness;
      if (_random.nextDouble() < 0.05) {
        newCleanliness = (current.cleanliness - 15).clamp(0, 100);
        print(
          '[TamagotchiService] POOP EVENT! Cleanliness: ${current.cleanliness} -> $newCleanliness',
        );
      }

      final updated = current.copyWith(
        hunger: newHunger,
        energy: newEnergy,
        happiness: newHappiness,
        cleanliness: newCleanliness,
        lastUpdateTime: DateTime.now(),
      );
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onAccel(AccelerometerEvent e) {
    final g = sqrt(e.x * e.x + e.y * e.y + e.z * e.z) / GRAVITY_EARTH;
    if (g > gThreshold) {
      final now = DateTime.now().millisecondsSinceEpoch;
      _timestamps.add(now);
      _timestamps.removeWhere((t) => t < now - windowMs);

      if (_timestamps.length >= requiredCount) {
        _timestamps.clear();
        stopAccelerometer();
        // Trigger clear lice event
        add(const ClearLice());
      }
    }
  }


}
