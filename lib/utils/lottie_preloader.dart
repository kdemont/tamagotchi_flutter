import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:tamagotchi_flutter/config/tamagotchi_config.dart';

/// Lazy-loading Lottie animation manager with LRU cache to prevent memory overflow.
/// Only preloads the idle animation, then loads others on-demand.
class LottiePreloader {
  static final Map<String, LottieComposition> _cache = {};
  static final List<String> _accessOrder = [];
  static const int _maxCacheSize = 4; // Keep max 4 animations in memory

  /// Preload only essential animations (idle state) during splash
  static Future<void> preloadEssential() async {
    final essentialAnimations = [
      'cuddle.json', // idle animation
    ];

    for (final fileName in essentialAnimations) {
      await _loadAnimation(TamagotchiConfig.animationsPath + fileName);
    }

    debugPrint('[LottiePreloader] Essential animations preloaded');
  }

  /// Legacy method with progress - now only preloads essential animations
  static Future<void> preloadAllWithProgress(
      void Function(double progress, String assetName)? onProgress,
      ) async {
    onProgress?.call(0.0, 'Loading essential animations...');
    await preloadEssential();
    onProgress?.call(1.0, 'Complete');
  }

  /// Load an animation into cache with LRU eviction
  static Future<void> _loadAnimation(String path) async {
    if (!_cache.containsKey(path)) {
      // Evict least recently used if cache is full
      if (_cache.length >= _maxCacheSize) {
        final lruKey = _accessOrder.first;
        _accessOrder.removeAt(0);
        _cache.remove(lruKey);
        debugPrint('[LottiePreloader] Evicted LRU: $lruKey');
      }

      final composition = await AssetLottie(path).load();
      _cache[path] = composition;
      _accessOrder.add(path);
      debugPrint('[LottiePreloader] Loaded: $path (cache: ${_cache.length}/$_maxCacheSize)');
    } else {
      // Move to end of access order (most recently used)
      _accessOrder.remove(path);
      _accessOrder.add(path);
    }
  }

  /// Get composition, loading it on-demand if not cached
  static Future<LottieComposition?> getComposition(String path) async {
    if (!_cache.containsKey(path)) {
      await _loadAnimation(path);
    } else {
      // Update access order
      _accessOrder.remove(path);
      _accessOrder.add(path);
    }
    return _cache[path];
  }

  /// Get composition synchronously (returns null if not loaded)
  static LottieComposition? getCompositionSync(String path) {
    if (_cache.containsKey(path)) {
      // Update access order
      _accessOrder.remove(path);
      _accessOrder.add(path);
    }
    return _cache[path];
  }
}
