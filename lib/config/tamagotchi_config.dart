class TamagotchiConfig {
  TamagotchiConfig._();

  // ============================================================================
  // ASSET PATHS
  // ============================================================================

  static const String animationsPath = 'assets/animations/';

  // ============================================================================
  // VISUAL STATE PRIORITIES
  // ============================================================================

  /// Visual state priorities (higher value = can interrupt lower priority states)
  static const Map<String, int> visualStatePriorities = {
    'idle': 0,
    'crying': 2,
    'eating': 3,
    'cleaning': 3,
    'sleeping': 3,
    'liceAttack': 5,
  };

  // ============================================================================
  // EVENT PROBABILITIES
  // ============================================================================

  /// Poop appearance probability per tick (0.0 to 1.0)
  /// Default: 0.01 = 1% chance per tick
  static const double poopProbability = 0.01;

  /// Lice attack probability per tick (0.0 to 1.0)
  /// Default: 0.01 = 1% chance per tick
  static const double liceProbability = 0.01;

  // ============================================================================
  // TRIGGER DELAYS (in seconds)
  // ============================================================================

  /// System tick interval (in seconds)
  static const int tickIntervalSeconds = 1;

  /// Threshold before Tamagotchi starts crying (low stat)
  /// Triggered when hunger, energy or happiness < threshold
  static const int cryingThreshold = 30;

  /// Minimum duration between two lice attacks (in seconds)
  static const int liceAttackCooldown = 300; // 5 minutes

  /// Sleep session duration (in seconds)
  static const int sleepDuration = 120; // 2 minutes

  /// Delay before poop affects cleanliness (in seconds)
  static const int poopDecayDelay = 60; // 1 minute

  // ============================================================================
  // STAT DECAY
  // ============================================================================

  /// Hunger decay per tick
  static const int hungerDecayPerTick = 2;

  /// Energy decay per tick
  static const int energyDecayPerTick = 1;

  /// Happiness decay per tick (normal)
  static const int happinessDecayPerTick = 1;

  /// Happiness decay per tick (when hunger or energy < 30)
  static const int happinessDecayPerTickStressed = 2;

  /// Cleanliness decay per tick (outside of events)
  static const int cleanlinessDecayPerTick = 0;

  /// Cleanliness loss during a poop event
  static const int poopCleanlinessLoss = 15;

  // ============================================================================
  // ACTION GAINS
  // ============================================================================

  /// Hunger gain when feeding
  static const int feedHungerGain = 30;

  /// Happiness gain when playing
  static const int playHappinessGain = 25;

  /// Energy gain when sleeping
  static const int sleepEnergyGain = 50;

  /// Cleanliness gain when cleaning
  static const int cleanCleanlinessGain = 40;

  // ============================================================================
  // PETTING SETTINGS
  // ============================================================================

  /// Number of rubs required to trigger petting bonus
  static const int rubsForPet = 5;

  /// Happiness gain when petting
  static const int petHappinessGain = 10;

  // ============================================================================
  // WALK / PEDOMETER SETTINGS
  // ============================================================================

  /// Number of steps required to complete one walk
  static const int stepsPerWalk = 1000;

  /// Energy gained per completed walk
  static const int walkEnergyGain = 10;

  /// Happiness gained per completed walk
  static const int walkHappinessGain = 15;

  /// Energy lost (fatigue) per completed walk
  static const int walkEnergyLoss = 5;

  // ============================================================================
  // DETECTION THRESHOLDS
  // ============================================================================

  static const double gravity = 9.80665; // in m/s²

  /// Accelerometer threshold to detect a shake (in g)
  static const double shakeThreshold = 2.5;

  /// Number of shakes required to eliminate lice
  static const int shakesToClearLice = 10;

  /// Time window to count shakes (in seconds)
  static const int shakeTimeWindow = 3;

  // ============================================================================
  // LIGHT SENSOR THRESHOLDS
  // ============================================================================

  /// Light threshold to detect darkness (in lux)
  static const double lightThresholdAndroid = 50;  // lux threshold for darkness (camera-based sensor)
  static const double lightThresholdIOS = 1;  // lux threshold for darkness (camera-based sensor)

  // ============================================================================
  // STAT LIMITS
  // ============================================================================

  /// Maximum value for all stats
  static const int maxStatValue = 100;

  /// Minimum value for all stats
  static const int minStatValue = 0;

  /// Maximum number of poops
  static const int maxPoopCount = 3;

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Returns the priority of a visual state
  static int getPriority(String visualState) {
    return visualStatePriorities[visualState] ?? 0;
  }

  /// Checks if a new state can interrupt the current state
  static bool canInterrupt(String currentState, String newState) {
    final currentPriority = getPriority(currentState);
    final newPriority = getPriority(newState);
    return newPriority > currentPriority;
  }

  /// Clamps a stat value between min and max
  static int clampStat(int value) {
    return value.clamp(minStatValue, maxStatValue);
  }
}
