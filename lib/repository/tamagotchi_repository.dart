import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tamagotchi.dart';

/// Repository that persists Tamagotchi state using SharedPreferences.
class TamagotchiRepository {
  static const _prefsKey = 'tamagotchi_v1';

  Future<Tamagotchi> getTamagotchi() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return Tamagotchi.fromJson(map);
      } catch (_) {
        // Fall back to initial if parsing fails
      }
    }
    final initial = Tamagotchi.initial();
    // ensure initial state saved
    await saveTamagotchi(initial);
    return initial;
  }

  Future<void> saveTamagotchi(Tamagotchi t) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(t.toJson());
    await prefs.setString(_prefsKey, raw);
  }

  // Reset tamagotchi to initial state (for development/testing)
  // TODO: remove once in production
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    print('[TamagotchiRepository] Data reset to initial state');
  }
}
