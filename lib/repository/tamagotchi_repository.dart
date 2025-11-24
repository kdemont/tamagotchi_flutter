import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tamagotchi.dart';

/// Repository that persists Tamagotchi state using SharedPreferences.
class TamagotchiRepository {
  static const _prefsKey = 'tamagotchi_v1';
  // static const _prefsTimeKey = 'tamagotchi_v1_last_saved_ms';

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
    // store last saved timestamp (ms since epoch)
    // await prefs.setInt(_prefsTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Returns the DateTime when tamagotchi was last saved, or null if none.
  Future<DateTime?> getLastSavedTime() async {
    final prefs = await SharedPreferences.getInstance();
    // final ms = prefs.getInt(_prefsTimeKey);
    // if (ms == null) return null;
    // return DateTime.fromMillisecondsSinceEpoch(ms);
  }
}
