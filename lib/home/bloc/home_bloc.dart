import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ambient_light/ambient_light.dart';
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

  // Accelerometer subscription for shake detection
  StreamSubscription<AccelerometerEvent>? _accelSub;
  final List<int> _timestamps = [];

  // Light sensor for sleep detection
  final AmbientLight _ambientLight = AmbientLight();
  StreamSubscription<double>? _lightSub;

  static const double lightThreshold = 50.0; // lux threshold for darkness
  bool _isSleeping = false; // prevent multiple sleep triggers

  void startAccelerometer() {
    if (_accelSub != null) return;
    _accelSub = accelerometerEventStream().listen(_onAccel);
  }

  void stopAccelerometer() {
    _accelSub?.cancel();
    _accelSub = null;
    _timestamps.clear();
  }

  void startLightSensor() {
    if (_lightSub != null) return;
    try {
      _lightSub = _ambientLight.ambientLightStream.listen(_onLight);
    } catch (e) {
      print('[HomeBloc] Light sensor not available: $e');
    }
  }

  void stopLightSensor() {
    _lightSub?.cancel();
    _lightSub = null;
  }

  Timer? _ticker;
  // optional counter for batching saves (unused for now)
  // int _unsavedTickCounter = 0;
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadTamagotchi>(_onLoad);
    on<Feed>(_onFeed);
    on<Play>(_onPlay);
    on<Sleep>(_onSleep);
    on<WakeUp>(_onWakeUp);
    on<Clean>(_onClean);
    on<Tick>(_onTick);
    on<LiceAttack>(_onLiceAttack);
    on<ClearLice>(_onClearLice);
    on<NonRepeatingEventComplete>(_onNonRepeatingEventComplete);
    on<PoopEvent>(_onPoopEvent);
    on<StartCleaning>(_onStartCleaning);
    on<RubPoop>(_onRubPoop);
    on<ExitCleaning>(_onExitCleaning);
    _startTicker();
    startLightSensor(); // Start listening to light sensor
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
    stopLightSensor();
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

      // Passer en état sleeping - l'énergie sera récupérée progressivement dans _onTick
      final updated = current.copyWith(
        state: VisualState.sleeping,
        lastUpdateTime: DateTime.now(),
      );

      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onWakeUp(WakeUp event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;

      final updated = current.copyWith(
        state: VisualState.idle,
        lastUpdateTime: DateTime.now(),
      );
      // clearing lice slightly reduces cleanliness
      repository.saveTamagotchi(updated);
      emit(HomeLoaded(tamagotchi: updated));
    }
  }

  void _onClean(Clean event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      // If there are poops, enter cleaning mode instead of regular cleaning
      if (current.poopCount > 0) {
        add(const StartCleaning());
        return;
      }

      // Regular cleaning if no poops
      if (VisualState.canInterrupt(current.state, VisualState.cleaning)) {
        final newCleanliness = (current.cleanliness + 30).clamp(0, 100);
        final updated = current.copyWith(
          cleanliness: newCleanliness,
          state: VisualState.cleaning,
          lastUpdateTime: DateTime.now(),
        );
        repository.saveTamagotchi(updated);
        emit(currentState.copyWith(tamagotchi: updated));
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

      // Si le tamagotchi dort, il récupère de l'énergie et ne perd pas de stats
      if (current.state == VisualState.sleeping) {
        final newEnergy = (current.energy + 5).clamp(0, 100);
        print(
          '[TamagotchiService] Sleeping - Energy: ${current.energy} -> $newEnergy',
        );

        final updated = current.copyWith(
          energy: newEnergy,
          lastUpdateTime: DateTime.now(),
        );
        repository.saveTamagotchi(updated);
        emit(HomeLoaded(tamagotchi: updated));
        return; // Ne pas exécuter le reste du tick pendant le sommeil
      }

      // small chance to trigger lice attack when not already infested
      if (current.state != VisualState.liceAttack) {
        double liceChance = 0.05; // base 5% per tick
        if (current.cleanliness < 30) {
          liceChance += 0.2; // +20% if dirty
        }

        // e.g. 0.5% chance per tick
        if (_random.nextDouble() < liceChance) {
          //print('[TamagotchiBloc] Lice Attack triggered by tick');
          add(const LiceAttack());
        }
      }

      final newHunger = (current.hunger - 2).clamp(0, 100);
      //print('[TamagotchiService] Hunger: ${current.hunger} -> $newHunger');

      final newEnergy = (current.energy - 1).clamp(0, 100);
      //print('[TamagotchiService] Energy: ${current.energy} -> $newEnergy');

      int newHappiness;
      if (current.hunger < 30 || current.energy < 30) {
        newHappiness = (current.happiness - 2).clamp(0, 100);
        /*print(
          '[TamagotchiService] Happiness: ${current.happiness} -> $newHappiness (low stats penalty)',
        );*/
      } else {
        newHappiness = (current.happiness - 1).clamp(0, 100);
        /*print(
          '[TamagotchiService] Happiness: ${current.happiness} -> $newHappiness',
        );*/
      }

      // Check for poop event (5% chance per tick)
      if (_random.nextDouble() < 0.05) {
        add(const PoopEvent());
        return; // PoopEvent handler will update the state
      }

      final updated = current.copyWith(
        hunger: newHunger,
        energy: newEnergy,
        happiness: newHappiness,
        lastUpdateTime: DateTime.now(),
      );
      repository.saveTamagotchi(updated);
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(tamagotchi: updated));
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

  void _onLight(double lux) {
    if (state is HomeLoaded) {
      final current = (state as HomeLoaded).tamagotchi;

      // print(
      //    '[HomeBloc] Light sensor: ${lux.toStringAsFixed(2)} lux, current state: ${current.state}, isSleeping: $_isSleeping',
      // );

      if (lux < lightThreshold && !_isSleeping) {
        // It's dark, trigger sleep if no higher priority event
        if (VisualState.canInterrupt(current.state, VisualState.sleeping)) {
          print(
            '[HomeBloc] Light sensor: ${lux.toStringAsFixed(2)} lux (dark) - triggering Sleep',
          );
          _isSleeping = true;
          add(const Sleep());
        }
      } else if (lux >= lightThreshold && _isSleeping) {
        // Light is back, reset sleep flag
        print(
          '[HomeBloc] Light sensor: ${lux.toStringAsFixed(2)} lux (bright) - waking up',
        );
        _isSleeping = false;
        add(const WakeUp());
      }
    }
  }
  
  Future<void> _onPoopEvent(PoopEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      // Increment poop count and decrease cleanliness
      final newPoopCount = current.poopCount + 1;
      final updated = current.copyWith(
        poopCount: newPoopCount,
        cleanliness: (current.cleanliness - 15).clamp(0, 100),
        lastUpdateTime: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  Future<void> _onStartCleaning(
    StartCleaning event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      if (currentState.tamagotchi.poopCount > 0) {
        emit(currentState.copyWith(
          isCleaningMode: true,
          poopRubCounts: [0, 0, 0],
        ));
      }
    }
  }

  Future<void> _onRubPoop(RubPoop event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      if (!currentState.isCleaningMode) return;

      final poopIndex = event.poopIndex;
      if (poopIndex >= currentState.tamagotchi.poopCount) return;

      // Increment rub count for this poop
      final newRubCounts = List<int>.from(currentState.poopRubCounts);
      newRubCounts[poopIndex]++;

      // If this poop has been rubbed 5 times, remove it
      if (newRubCounts[poopIndex] >= 5) {
        final current = currentState.tamagotchi;
        final newPoopCount = current.poopCount - 1;
        final updated = current.copyWith(
          poopCount: newPoopCount,
          cleanliness: (current.cleanliness + 10).clamp(0, 100),
          lastUpdateTime: DateTime.now(),
        );
        await repository.saveTamagotchi(updated);

        // Reset rub counts and check if we should exit cleaning mode
        if (newPoopCount == 0) {
          emit(HomeLoaded(
            tamagotchi: updated,
            isCleaningMode: false,
            poopRubCounts: [0, 0, 0],
          ));
        } else {
          emit(currentState.copyWith(
            tamagotchi: updated,
            poopRubCounts: [0, 0, 0],
          ));
        }
      } else {
        emit(currentState.copyWith(poopRubCounts: newRubCounts));
      }
    }
  }

  Future<void> _onExitCleaning(
    ExitCleaning event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(
        isCleaningMode: false,
        poopRubCounts: [0, 0, 0],
      ));
    }
  }
}
