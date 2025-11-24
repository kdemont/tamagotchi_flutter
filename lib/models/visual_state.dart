enum VisualState {
  idle(0),
  yawning(1),
  hungry(1),
  crying(2),
  sleeping(2),
  eating(3),
  cleaning(3),
  liceAttack(4);

  final int priority;
  const VisualState(this.priority);

  /// Determines if `newState` can interrupt `current`.
  static bool canInterrupt(VisualState current, VisualState newState) {
    return newState.priority > current.priority;
  }
}
