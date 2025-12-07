import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tamagotchi_flutter/utils/lottie_preloader.dart';
import 'app.dart';
import 'models/visual_state.dart';
import 'utils/my_lottie_cache.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Preload all Lottie animations for immediate availability
  //await MyLottieCache.instance.preloadAll();

  //await LottiePreloader.preloadAll();

  //await LottiePreloader.preloadAll();


  // for (final state in VisualState.values) {
  //   for (final anim in state.animations) {
  //     AssetLottie(anim.assetFileName).load(context: null);
  //     print('Preloaded Lottie: ${anim.assetFileName}');
  //   }
  // }

  runApp(const MyApp());
}
