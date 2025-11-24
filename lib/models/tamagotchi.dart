class Tamagotchi {
  final String name;
  final int hunger;
  final int energy;
  final int happiness;
  final int cleanliness;
  final int age;

  Tamagotchi({
    required this.name,
    required this.hunger,
    required this.energy,
    required this.happiness,
    required this.cleanliness,
    required this.age,
  });

  Tamagotchi copyWith({
    String? name,
    int? hunger,
    int? energy,
    int? happiness,
    int? cleanliness,
    int? age,
  }) {
    return Tamagotchi(
      name: name ?? this.name,
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      cleanliness: cleanliness ?? this.cleanliness,
      age: age ?? this.age,
    );
  }

  factory Tamagotchi.initial() => Tamagotchi(
    name: "Tama",
    hunger: 100,
    energy: 100,
    happiness: 100,
    cleanliness: 100,
    age: 0,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hunger': hunger,
      'energy': energy,
      'happiness': happiness,
      'cleanliness': cleanliness,
      'age': age,
    };
  }

  factory Tamagotchi.fromJson(Map<String, dynamic> json) => Tamagotchi(
    name: json['name'] as String? ?? 'Tama',
    hunger: (json['hunger'] as num?)?.toInt() ?? 100,
    energy: (json['energy'] as num?)?.toInt() ?? 100,
    happiness: (json['happiness'] as num?)?.toInt() ?? 100,
    cleanliness: (json['cleanliness'] as num?)?.toInt() ?? 100,
    age: (json['age'] as num?)?.toInt() ?? 0,
  );
}
