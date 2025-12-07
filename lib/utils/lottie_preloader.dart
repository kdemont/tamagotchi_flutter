import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../models/visual_state.dart';
import 'constants.dart';


// Transformer en singleton si besoin plus tard ?
class LottiePreloader {
  static final Map<String, LottieComposition> _cache = {};

  static Future<void> preloadAll() async {
    final List<String> allAssets = [];
    for (final state in VisualState.values) {
      for (final anim in state.animations) {
        allAssets.add(anim.assetFileName);
      }
    }

    await Future.wait(
        allAssets.map((path) => _preloadAnimation(ANIMATION_ASSET_PATH + path))
    );
  }

  static Future<void> preloadAllWithProgress(
      void Function(double progress, String assetName)? onProgress,
      ) async {

    final List<String> allAssets = [];
    for (final state in VisualState.values) {
      for (final anim in state.animations) {
        allAssets.add(anim.assetFileName);
      }
    }

    print(
      '[LottieCache] Preloading ${allAssets.length} animations: $allAssets',
    );

    for (int i = 0; i < allAssets.length; i++) {
      final fileName = allAssets[i];
      onProgress?.call(i / allAssets.length, fileName);
      await _preloadAnimation(ANIMATION_ASSET_PATH + fileName);
    }

    onProgress?.call(1.0, 'Complete');
    print(
      '[LottieCache] Preload complete. Cache keys: ${_cache.keys.toList()}',
    );
  }

  static Future<void> _preloadAnimation(String path) async {
    if (!_cache.containsKey(path)) {
      final composition = await AssetLottie(path).load();
      _cache[path] = composition;
      debugPrint('[LottiePreloader] Preloaded: $path' );
    }
  }

  static LottieComposition? getComposition(String path) {
    return _cache[path];
  }
}