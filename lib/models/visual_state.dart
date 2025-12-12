import 'package:tamagotchi_flutter/config/tamagotchi_config.dart';

enum VisualState {
  idle([VisualAnimation('cuddle.json', true)]),
  //yawning([VisualAnimation('yawning.json', false)]),
  // hungry([VisualAnimation('hungry.json', false)]),
  happy([VisualAnimation('happy_bouncing.json', false)]),
  crying([VisualAnimation('crying.json', false)]),
  eating([VisualAnimation('eating.json', false)]),
  cleaning([VisualAnimation('cleaning.json', false)]),
  liceAttack([
    VisualAnimation('lice_attack_init_opt.json', false),
    VisualAnimation('lice_attack_cycle_opt.json', true),
  ]),
  sleeping([
    VisualAnimation('sleeping_init.json', false),
    VisualAnimation('sleeping_cycle.json', true),
  ]);

  final List<VisualAnimation> animations;
  const VisualState(this.animations);

  /// Returns priority from TamagotchiConfig
  int get priority => TamagotchiConfig.getPriority(name);

  /// Determines if `newState` can interrupt `current`.
  static bool canInterrupt(VisualState current, VisualState newState) {
    return TamagotchiConfig.canInterrupt(current.name, newState.name);
  }
}

class VisualAnimation {
  final String assetFileName;
  final bool repeat; // controller à la place ?

  const VisualAnimation(this.assetFileName, this.repeat);
}