enum VisualState {
  idle(0, 'cuddle.json'),
  yawning(1, 'yawning.json'),
  hungry(1, 'hungry.json'),
  crying(2, 'crying.json'),
  sleeping(2, 'sleeping.json'),
  eating(3, 'eating.json'),
  cleaning(3, 'cleaning.json'),
  liceAttack(4, 'lice_attack.json'),;

  final int priority;
  final String assetFileName;
  const VisualState(this.priority, this.assetFileName);

  /// Determines if `newState` can interrupt `current`.
  static bool canInterrupt(VisualState current, VisualState newState) {
    return newState.priority > current.priority;
  }
}
