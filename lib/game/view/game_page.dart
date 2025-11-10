import 'package:flutter/material.dart';
import '../../home/view/home_page.dart';
import '../../achievements/view/achievements_page.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jeu')),
      body: const Center(child: Text('Page Jeu - à implémenter')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AchievementsPage()),
            );
          }
        },
      ),
    );
  }
}
