import 'package:flutter/material.dart';

import '../models/tamagotchi.dart';
import '../repository/tamagotchi_repository.dart';
import '../home/view/home_page.dart';
import '../naming/view/naming_page.dart';
import '../game_over/game_over_page.dart';

/// Widget that determines the initial route based on tamagotchi state.
class AppRouter extends StatelessWidget {
  final TamagotchiRepository repository;

  const AppRouter({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tamagotchi>(
      future: repository.getTamagotchi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          // Error or no data, start fresh
          return const NamingPage();
        }

        final tama = snapshot.data!;

        // Si c'est le tamagotchi initial (nom par défaut et stats pleines),
        // proposer de le nommer
        if (tama.name == '' &&
            tama.hunger == 100 &&
            tama.energy == 100 &&
            tama.age == 0) {
          return const NamingPage();
        }

        // Si le tamagotchi est mort, aller à la page game over
        if (tama.isDead) {
          return GameOverPage(tamagotchiName: tama.name, age: tama.age);
        }

        // Sinon, reprendre le jeu
        return const HomePage();
      },
    );
  }
}
