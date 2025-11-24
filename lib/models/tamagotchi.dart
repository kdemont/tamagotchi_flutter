import 'package:tamagotchi_flutter/models/visual_state.dart';

class Tamagotchi {
  final String name;
  final int hunger;
  final int energy;
  final int happiness;
  final int cleanliness;
  final int age; // creation date puis calculé ?
  final DateTime lastUpdateTime;
  final VisualState state;

  Tamagotchi({
    required this.name,
    required this.hunger,
    required this.energy,
    required this.happiness,
    required this.cleanliness,
    required this.age,
    required this.lastUpdateTime,
    required this.state,
  });

  Tamagotchi copyWith({
    String? name,
    int? hunger,
    int? energy,
    int? happiness,
    int? cleanliness,
    int? age,
    DateTime? lastUpdateTime,
    VisualState? state,
  }) {
    return Tamagotchi(
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      cleanliness: cleanliness ?? this.cleanliness,
      age: age ?? this.age,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      state: state ?? this.state,
    );
  }

  factory Tamagotchi.initial() => Tamagotchi(
    name: "Tama",
    hunger: 100,
    energy: 100,
    happiness: 100,
    cleanliness: 100,
    age: 0,
    lastUpdateTime: DateTime.now(),
    state: VisualState.idle,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hunger': hunger,
      'energy': energy,
      'happiness': happiness,
      'cleanliness': cleanliness,
      'age': age,
      'lastUpdateTime': lastUpdateTime.toIso8601String(),
      'state': state.toString().split('.').last,
    };
  }

  factory Tamagotchi.fromJson(Map<String, dynamic> json) => Tamagotchi(
    name: json['name'] as String? ?? 'Tama',
    hunger: (json['hunger'] as num?)?.toInt() ?? 100,
    energy: (json['energy'] as num?)?.toInt() ?? 100,
    happiness: (json['happiness'] as num?)?.toInt() ?? 100,
    cleanliness: (json['cleanliness'] as num?)?.toInt() ?? 100,
    age: (json['age'] as num?)?.toInt() ?? 0,
    lastUpdateTime: json['lastUpdateTime'] != null
        ? DateTime.parse(json['lastUpdateTime'] as String)
        : DateTime.now(),
    state: json['state'] != null
        ? VisualState.values.firstWhere(
          (e) => e.toString().split('.').last == json['state'],
      orElse: () => VisualState.idle,
    )
        : VisualState.idle,
  );
}
