import 'dart:async';
import 'dart:math';

import '../models/tamagotchi.dart';
import '../repository/tamagotchi_repository.dart';

class TamagotchiService {
  final TamagotchiRepository repository;
  Timer? _tickTimer;
  final Random _random = Random();

  // Duration between ticks (10 seconds)
  static const tickDuration = Duration(seconds: 10);

  // Notify listeners of tamagotchi updates
  final _tamagotchiController = StreamController<Tamagotchi>.broadcast();
  Stream<Tamagotchi> get tamagotchiStream => _tamagotchiController.stream;

  TamagotchiService({required this.repository});

  // Start the time-based events system
  // It also handle missed events, then start the timer
  Future<void> start() async {
    _tickTimer?.cancel(); // Ensure no duplicate timers

    // Apply retroactive events on startup
    await _applyMissedEvents();

    _tickTimer = Timer.periodic(tickDuration, (_) {
      _processTick();
    });
  }

  /// Stop the time-based events system
  void stop() {
    _tickTimer?.cancel();
  }

  // Apply all missed events since last update
  Future<void> _applyMissedEvents() async {
    final current = await repository.getTamagotchi();
    final now = DateTime.now();
    final timeSinceLastUpdate = now.difference(current.lastUpdateTime);

    // Calculate elapsed ticks
    final missedTicks = timeSinceLastUpdate.inSeconds ~/ tickDuration.inSeconds;

    if (missedTicks == 0) {
      print('[TamagotchiService] No missed events to catch up');
      return;
    }

    print('[TamagotchiService] Catching up on $missedTicks missed ticks (${timeSinceLastUpdate.inMinutes} minutes elapsed)');

    // Apply all missed ticks
    var updated = current;
    for (var i = 0; i < missedTicks; i++) {
      updated = _applyTickEffects(updated);
    }

    // Update the timestamp to now
    updated = updated.copyWith(lastUpdateTime: now);

    await repository.saveTamagotchi(updated);
    _tamagotchiController.add(updated);

    print('[TamagotchiService] Catch-up complete');
    print('[TamagotchiService] Final stats - H:${updated.hunger} E:${updated.energy} Ha:${updated.happiness} C:${updated.cleanliness}\n');
  }

  Future<void> _processTick() async {
    final current = await repository.getTamagotchi();

    print('[TamagotchiService] Time-based event triggered');

    final updated = _applyTickEffects(current).copyWith(
      lastUpdateTime: DateTime.now(),
    );

    await repository.saveTamagotchi(updated);

    // Notify listeners of the update
    _tamagotchiController.add(updated);
    print('[TamagotchiService] Update complete and broadcasted\n');
  }


  Tamagotchi _applyTickEffects(Tamagotchi tama) {

    final newHunger = (tama.hunger - 2).clamp(0, 100);
    print('[TamagotchiService] Hunger: ${tama.hunger} -> $newHunger');

    final newEnergy = (tama.energy - 1).clamp(0, 100);
    print('[TamagotchiService] Energy: ${tama.energy} -> $newEnergy');

    int newHappiness;
    if (tama.hunger < 30 || tama.energy < 30) {
      newHappiness = (tama.happiness - 2).clamp(0, 100);
      print('[TamagotchiService] Happiness: ${tama.happiness} -> $newHappiness (low stats penalty)');
    } else {
      newHappiness = (tama.happiness - 1).clamp(0, 100);
      print('[TamagotchiService] Happiness: ${tama.happiness} -> $newHappiness');
    }

    var newCleanliness = tama.cleanliness;
    if (_random.nextDouble() < 0.2) {
      newCleanliness = (tama.cleanliness - 15).clamp(0, 100);
      print('[TamagotchiService] POOP EVENT! Cleanliness: ${tama.cleanliness} -> $newCleanliness');
    }

    return tama.copyWith(
      hunger: newHunger,
      energy: newEnergy,
      happiness: newHappiness,
      cleanliness: newCleanliness,
    );
  }

  // Reset tamagotchi to initial state (for development/testing)
  // TODO: Remove in production
  Future<void> reset() async {
    print('[TamagotchiService] Resetting tamagotchi...');
    await repository.reset();
    final initial = await repository.getTamagotchi();
    _tamagotchiController.add(initial);
    print('[TamagotchiService] Reset complete');
  }

  void dispose() {
    _tickTimer?.cancel();
    _tamagotchiController.close();
  }
}
