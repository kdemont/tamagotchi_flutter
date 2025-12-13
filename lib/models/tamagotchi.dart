import 'package:tamagotchi_flutter/models/visual_state.dart';

class Tamagotchi {

  // Pourquoi mettre final ?
  final String name;
  final int hunger;
  final int energy;
  final int happiness;
  final int cleanliness;
  final DateTime creationDate;
  final DateTime lastUpdateTime;
  final VisualState state;
  final int poopCount; // Number of poops (max 3 visible)
  final int lastStepCount; // Last recorded step count
  final DateTime? lastWalkDate; // Date of last step count check
  final int totalWalks; // Total number of completed walks

  Tamagotchi({
    required this.name,
    required this.hunger,
    required this.energy,
    required this.happiness,
    required this.cleanliness,
    required this.creationDate,
    required this.lastUpdateTime,
    required this.state,
    this.poopCount = 0,
    this.lastStepCount = 0,
    this.lastWalkDate,
    this.totalWalks = 0,
  });

  Tamagotchi copyWith({
    String? name,
    int? hunger,
    int? energy,
    int? happiness,
    int? cleanliness,
    DateTime? lastUpdateTime,
    VisualState? state,
    int? poopCount,
    int? lastStepCount,
    DateTime? lastWalkDate,
    int? totalWalks,
  }) {
    return Tamagotchi(
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      cleanliness: cleanliness ?? this.cleanliness,
      creationDate: creationDate,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      state: state ?? this.state,
      poopCount: poopCount ?? this.poopCount,
      lastStepCount: lastStepCount ?? this.lastStepCount,
      lastWalkDate: lastWalkDate ?? this.lastWalkDate,
      totalWalks: totalWalks ?? this.totalWalks,
    );
  }

  factory Tamagotchi.initial() => Tamagotchi(
    name: "",
    hunger: 100,
    energy: 100,
    happiness: 100,
    cleanliness: 100,
    creationDate: DateTime.now(),
    lastUpdateTime: DateTime.now(),
    state: VisualState.idle,
    poopCount: 0,
    lastStepCount: 0,
    lastWalkDate: DateTime.now(),
    totalWalks: 0,
  );

  /// Crée un nouveau tamagotchi avec le nom spécifié
  factory Tamagotchi.newWithName(String name) => Tamagotchi(
    name: name,
    hunger: 100,
    energy: 100,
    happiness: 100,
    cleanliness: 100,
    creationDate: DateTime.now(),
    lastUpdateTime: DateTime.now(),
    state: VisualState.idle,
    poopCount: 0,
    lastStepCount: 0,
    lastWalkDate: DateTime.now(),
    totalWalks: 0,
  );

  /// Vérifie si le tamagotchi est mort (toutes les stats à 0)
  bool get isDead =>
      hunger <= 0 && energy <= 0 && happiness <= 0 && cleanliness <= 0;

  int get age =>
      lastUpdateTime.difference(creationDate).inMinutes;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hunger': hunger,
      'energy': energy,
      'happiness': happiness,
      'cleanliness': cleanliness,
      'creationDate': creationDate.toIso8601String(),
      'lastUpdateTime': lastUpdateTime.toIso8601String(),
      'state': state.toString().split('.').last,
      'poopCount': poopCount,
      'lastStepCount': lastStepCount,
      'lastWalkDate': lastWalkDate?.toIso8601String(),
      'totalWalks': totalWalks,
    };
  }

  factory Tamagotchi.fromJson(Map<String, dynamic> json) => Tamagotchi(
    name: json['name'] as String? ?? '',
    hunger: (json['hunger'] as num?)?.toInt() ?? 100,
    energy: (json['energy'] as num?)?.toInt() ?? 100,
    happiness: (json['happiness'] as num?)?.toInt() ?? 100,
    cleanliness: (json['cleanliness'] as num?)?.toInt() ?? 100,
    creationDate: json['creationDate'] != null
        ? DateTime.parse(json['creationDate'] as String)
        : DateTime.now(),
    lastUpdateTime: json['lastUpdateTime'] != null
        ? DateTime.parse(json['lastUpdateTime'] as String)
        : DateTime.now(),
    state: json['state'] != null
        ? VisualState.values.firstWhere(
          (e) => e.toString().split('.').last == json['state'],
      orElse: () => VisualState.idle,
    )
        : VisualState.idle,
    poopCount: (json['poopCount'] as num?)?.toInt() ?? 0,
    lastStepCount: (json['lastStepCount'] as num?)?.toInt() ?? 0,
    lastWalkDate: json['lastWalkDate'] != null
        ? DateTime.parse(json['lastWalkDate'] as String)
        : null,
    totalWalks: (json['totalWalks'] as num?)?.toInt() ?? 0,
  );
}
