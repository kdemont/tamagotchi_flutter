import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ambient_light/ambient_light.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:pedometer/pedometer.dart';

import '../../config/tamagotchi_config.dart';
import '../../models/tamagotchi.dart';
import '../../models/visual_state.dart';
import '../../repository/tamagotchi_repository.dart';
import '../../utils/constants.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TamagotchiRepository repository;
  // Interval between ticks from config
  static final Duration tickInterval = Duration(
    seconds: TamagotchiConfig.tickIntervalSeconds,
  );

  // Constants for shake detection from config
  final double gThreshold = TamagotchiConfig.shakeThreshold;
  final int windowMs = TamagotchiConfig.shakeTimeWindow * 1000;
  final int requiredCount = TamagotchiConfig.shakesToClearLice;

  final Random _random = Random();

  // Accelerometer subscription for shake detection
  StreamSubscription<AccelerometerEvent>? _accelSub;
  final List<int> _timestamps = [];

  // Pedometer subscription for step counting
  StreamSubscription? _pedometerSub;

  // Light sensor for sleep detection
  // On iOS, use front camera to measure light
  final AmbientLight _ambientLight = AmbientLight(frontCamera: true);
  StreamSubscription<double>? _lightSub;

  static const double lightThreshold = 50; // lux threshold for darkness (camera-based sensor)
  // pour IOS
  bool? _isSleeping; // prevent multiple sleep triggers

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
      print('[HomeBloc] Starting light sensor...');
      _lightSub = _ambientLight.ambientLightStream.listen(
        _onLight,
        onError: (error) {
          print('[HomeBloc] Light sensor error: $error');
        },
        onDone: () {
          print('[HomeBloc] Light sensor stream closed');
        },
      );
      print('[HomeBloc] Light sensor started successfully - waiting for data...');
    } catch (e) {
      print('[HomeBloc] Light sensor not available: $e');
    }
  }

  void stopLightSensor() {
    _lightSub?.cancel();
    _lightSub = null;
  }

  void startPedometer() {
    if (_pedometerSub != null) return;
    try {
      _pedometerSub = Pedometer.stepCountStream.listen(
        (StepCount event) {
          add(UpdateSteps(event.steps));
        },
        onError: (error) {
          print('[HomeBloc] Pedometer error: $error');
        },
      );
    } catch (e) {
      print('[HomeBloc] Pedometer not available: $e');
    }
  }

  void stopPedometer() {
    _pedometerSub?.cancel();
    _pedometerSub = null;
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
    on<ResetPoopCount>(_onResetPoopCount);
    on<UpdateSteps>(_onUpdateSteps);
    on<Pet>(_onPet);
    _startTicker();
    startLightSensor(); // Start listening to light sensor
    startPedometer(); // Start listening to step counter
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
    stopPedometer();
    return super.close();
  }

  Future<void> _onLoad(LoadTamagotchi event, Emitter<HomeState> emit) async {
    final tama = await repository.getTamagotchi();

    // Check if we need to reset steps (new day)
    final now = DateTime.now();
    var updatedTama = tama;
    if (tama.lastWalkDate != null) {
      final lastDate = tama.lastWalkDate!;
      final isSameDay = now.year == lastDate.year &&
          now.month == lastDate.month &&
          now.day == lastDate.day;
      if (!isSameDay) {
        // Reset step count for new day
        updatedTama = tama.copyWith(
          lastStepCount: 0,
          lastWalkDate: now,
        );
        await repository.saveTamagotchi(updatedTama);
      }
    }

    // Apply ticks that occurred while the app was closed/backgrounded
    final elapsed = now.difference(updatedTama.lastUpdateTime);
    final ticks = elapsed.inSeconds ~/ tickInterval.inSeconds;
    if (ticks > 0) {
      final updated = updatedTama.copyWith(
        hunger: TamagotchiConfig.clampStat(
          updatedTama.hunger - (ticks * TamagotchiConfig.hungerDecayPerTick),
        ),
        energy: TamagotchiConfig.clampStat(
          updatedTama.energy - (ticks * TamagotchiConfig.energyDecayPerTick),
        ),
        happiness: TamagotchiConfig.clampStat(
          updatedTama.happiness - (ticks * TamagotchiConfig.happinessDecayPerTick),
        ),
        cleanliness: TamagotchiConfig.clampStat(
          updatedTama.cleanliness - (ticks * TamagotchiConfig.cleanlinessDecayPerTick),
        ),
        lastUpdateTime: now,
      );
      await repository.saveTamagotchi(updated);
      // if after applying elapsed ticks the tama is infested, start accelerometer
      if (updated.state == VisualState.liceAttack) {
        startAccelerometer();
      }
      emit(HomeLoaded(
        tamagotchi: updated,
        currentSteps: updated.lastStepCount,
      ));
      return;
    }

    // Emit loaded tama and start accelerometer if needed
    emit(HomeLoaded(
      tamagotchi: updatedTama,
      currentSteps: updatedTama.lastStepCount,
    ));
    if (updatedTama.state == VisualState.liceAttack) {
      startAccelerometer();
    }
  }

  void _onFeed(Feed event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;
      final updated = current.copyWith(
        hunger: TamagotchiConfig.clampStat(
          current.hunger + TamagotchiConfig.feedHungerGain,
        ),
        happiness: TamagotchiConfig.clampStat(current.happiness + 5),
        state: VisualState.eating,
        lastUpdateTime: DateTime.now(),
      );
      repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  void _onPlay(Play event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;
      final updated = current.copyWith(
        happiness: TamagotchiConfig.clampStat(
          current.happiness + TamagotchiConfig.playHappinessGain,
        ),
        energy: TamagotchiConfig.clampStat(current.energy - 10),
        lastUpdateTime: DateTime.now(),
      );
      repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  void _onSleep(Sleep event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      // Passer en état sleeping - l'énergie sera récupérée progressivement dans _onTick
      final updated = current.copyWith(
        state: VisualState.sleeping,
        lastUpdateTime: DateTime.now(),
      );

      repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  void _onWakeUp(WakeUp event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      final updated = current.copyWith(
        state: VisualState.idle,
        lastUpdateTime: DateTime.now(),
      );
      // clearing lice slightly reduces cleanliness
      repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
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
        final newCleanliness = TamagotchiConfig.clampStat(
          current.cleanliness + TamagotchiConfig.cleanCleanlinessGain,
        );
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
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      if (current.state == VisualState.liceAttack) return; // already infested

      startAccelerometer();

      final updated = current.copyWith(
        state: VisualState.liceAttack,
        lastUpdateTime: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  Future<void> _onClearLice(ClearLice event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;
      if (current.state != VisualState.liceAttack) return;

      stopAccelerometer();

      final updated = current.copyWith(
        state: VisualState.idle,
        cleanliness: TamagotchiConfig.clampStat(current.cleanliness + 20),
        lastUpdateTime: DateTime.now(),
      );
      // clearing lice slightly reduces cleanliness
      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  Future<void> _onNonRepeatingEventComplete(
    NonRepeatingEventComplete event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      final updated = current.copyWith(
        state: VisualState.idle,
        lastUpdateTime: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  void _onTick(Tick event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      // Si le tamagotchi dort, il récupère de l'énergie et ne perd pas de stats
      if (current.state == VisualState.sleeping) {
        final newEnergy = TamagotchiConfig.clampStat(
          current.energy + TamagotchiConfig.sleepEnergyGain,
        );
        print(
          '[TamagotchiService] Sleeping - Energy: ${current.energy} -> $newEnergy',
        );

        final updated = current.copyWith(
          energy: newEnergy,
          lastUpdateTime: DateTime.now(),
        );
        repository.saveTamagotchi(updated);
        emit(currentState.copyWith(tamagotchi: updated));
        return; // Ne pas exécuter le reste du tick pendant le sommeil
      }

      // Check for lice attack based on config probability
      if (current.state != VisualState.liceAttack) {
        double liceChance = TamagotchiConfig.liceProbability;
        if (current.cleanliness < TamagotchiConfig.cryingThreshold) {
          liceChance += 0.2; // +20% if dirty
        }

        if (_random.nextDouble() < liceChance) {
          add(const LiceAttack());
        }
      }

      final newHunger = TamagotchiConfig.clampStat(
        current.hunger - TamagotchiConfig.hungerDecayPerTick,
      );

      final newEnergy = TamagotchiConfig.clampStat(
        current.energy - TamagotchiConfig.energyDecayPerTick,
      );

      // Use different happiness decay rates based on stress
      final int happinessDecay = (current.hunger < TamagotchiConfig.cryingThreshold ||
              current.energy < TamagotchiConfig.cryingThreshold)
          ? TamagotchiConfig.happinessDecayPerTickStressed
          : TamagotchiConfig.happinessDecayPerTick;
      final newHappiness = TamagotchiConfig.clampStat(
        current.happiness - happinessDecay,
      );

      // Check for poop event based on config probability
      if (_random.nextDouble() < TamagotchiConfig.poopProbability) {
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

      // Log light level continuously
      print('[💡 Light] ${lux.toStringAsFixed(1)} lux ${lux < lightThreshold ? "🌙 DARK" : "☀️ BRIGHT"}');

      _isSleeping ??= lux < lightThreshold;

      if (lux < lightThreshold && !_isSleeping!) {
        // It's dark, trigger sleep if no higher priority event
        if (VisualState.canInterrupt(current.state, VisualState.sleeping)) {
          print('[😴 Sleep] Triggering sleep at ${lux.toStringAsFixed(1)} lux');
          _isSleeping = true;
          add(const Sleep());
        }
      } else if (lux >= lightThreshold && _isSleeping!) {
        // Light is back, reset sleep flag
        print('[👁️ Wake] Waking up at ${lux.toStringAsFixed(1)} lux');
        _isSleeping = false;
        add(const WakeUp());
      }
    }
  }
  
  Future<void> _onPoopEvent(PoopEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      // Don't add more poops if we've reached the maximum
      if (current.poopCount >= TamagotchiConfig.maxPoopCount) {
        return;
      }

      // Increment poop count and decrease cleanliness
      final newPoopCount = current.poopCount + 1;
      final updated = current.copyWith(
        poopCount: newPoopCount,
        cleanliness: TamagotchiConfig.clampStat(
          current.cleanliness - TamagotchiConfig.poopCleanlinessLoss,
        ),
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
          globalRubCount: 0,
        ));
      }
    }
  }

  Future<void> _onRubPoop(RubPoop event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      if (!currentState.isCleaningMode) return;
      if (currentState.tamagotchi.poopCount == 0) return;

      // Increment global rub count
      final newRubCount = currentState.globalRubCount + 1;

      // If we've reached 5 rubs, remove one poop (always the first/oldest one)
      if (newRubCount >= 5) {
        final current = currentState.tamagotchi;
        final newPoopCount = current.poopCount - 1;
        final updated = current.copyWith(
          poopCount: newPoopCount,
          cleanliness: TamagotchiConfig.clampStat(current.cleanliness + 10),
          lastUpdateTime: DateTime.now(),
        );
        await repository.saveTamagotchi(updated);

        // Reset rub count and check if we should exit cleaning mode
        if (newPoopCount == 0) {
          emit(currentState.copyWith(
            tamagotchi: updated,
            isCleaningMode: false,
            globalRubCount: 0,
          ));
        } else {
          emit(currentState.copyWith(
            tamagotchi: updated,
            globalRubCount: 0, // Reset count for next poop
          ));
        }
      } else {
        emit(currentState.copyWith(globalRubCount: newRubCount));
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
        globalRubCount: 0,
      ));
    }
  }

  Future<void> _onResetPoopCount(
    ResetPoopCount event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final current = currentState.tamagotchi;

      final updated = current.copyWith(
        poopCount: 0,
        lastUpdateTime: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(tamagotchi: updated));
    }
  }

  Future<void> _onUpdateSteps(
    UpdateSteps event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final current = currentState.tamagotchi;

    // Calculate steps since last update
    final stepsSinceLastUpdate = event.stepCount - current.lastStepCount;

    // Check if we completed any walks
    if (stepsSinceLastUpdate >= TamagotchiConfig.stepsPerWalk) {
      final completedWalks = stepsSinceLastUpdate ~/ TamagotchiConfig.stepsPerWalk;

      // Apply walk bonuses
      final updated = current.copyWith(
        energy: TamagotchiConfig.clampStat(
          current.energy + (completedWalks * TamagotchiConfig.walkEnergyGain) - (completedWalks * TamagotchiConfig.walkEnergyLoss),
        ),
        happiness: TamagotchiConfig.clampStat(
          current.happiness + (completedWalks * TamagotchiConfig.walkHappinessGain),
        ),
        lastStepCount: event.stepCount,
        lastWalkDate: DateTime.now(),
        totalWalks: current.totalWalks + completedWalks,
        lastUpdateTime: DateTime.now(),
      );

      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(
        tamagotchi: updated,
        currentSteps: event.stepCount,
      ));
    } else {
      // Just update the step count without applying bonuses
      final updated = current.copyWith(
        lastStepCount: event.stepCount,
        lastWalkDate: DateTime.now(),
      );
      await repository.saveTamagotchi(updated);
      emit(currentState.copyWith(
        tamagotchi: updated,
        currentSteps: event.stepCount,
      ));
    }
  }

  void _onPet(Pet event, Emitter<HomeState> emit) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final current = currentState.tamagotchi;

    // Only allow petting in idle state
    if (current.state != VisualState.idle) return;

    final updated = current.copyWith(
      happiness: TamagotchiConfig.clampStat(
        current.happiness + TamagotchiConfig.petHappinessGain,
      ),
      lastUpdateTime: DateTime.now(),
    );

    repository.saveTamagotchi(updated);
    emit(currentState.copyWith(tamagotchi: updated));
  }
}
