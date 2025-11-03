import '../models/tamagotchi.dart';

/// Simple in-memory repository for Tamagotchi state.
class TamagotchiRepository {
  Tamagotchi? _store;

  Future<Tamagotchi> getTamagotchi() async {
    // simulate delay
    await Future.delayed(const Duration(milliseconds: 100));
    _store ??= Tamagotchi.initial();
    return _store!;
  }

  Future<void> saveTamagotchi(Tamagotchi t) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _store = t;
  }
}
