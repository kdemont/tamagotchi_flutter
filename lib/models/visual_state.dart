enum VisualState {
  idle(0, [VisualAnimation('cuddle.json', true)]),
  //yawning(1, [VisualAnimation('yawning.json', false)]),
 // hungry(1, [VisualAnimation('hungry.json', false)]),
  //happy(1, [VisualAnimation('happy_bouncing.json', false)]),
  crying(2, [VisualAnimation('crying.json', false)]),
  //sleeping(2, [VisualAnimation('sleeping.json', true)]),
  eating(3, [VisualAnimation('happy_bouncing.json', false)]),
  cleaning(3, [VisualAnimation('cleaning.json', false)]),
  liceAttack(4, [VisualAnimation('lice_attack_init.json', false),
                  VisualAnimation('lice_attack_cycle.json', true)]);

  final int priority;
  final List<VisualAnimation> animations;
  const VisualState(this.priority, this.animations);

  /// Determines if `newState` can interrupt `current`.
  static bool canInterrupt(VisualState current, VisualState newState) {
    return newState.priority > current.priority;
  }
}

class VisualAnimation {
  final String assetFileName;
  final bool repeat; // controller à la place ?

  const VisualAnimation(this.assetFileName, this.repeat);
}