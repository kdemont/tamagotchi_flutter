import 'package:flutter/material.dart';
import 'package:tamagotchi_flutter/gen/strings.g.dart';
import '../../home/view/home_page.dart';
import '../../game/view/game_page.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.achievements.title)),
      body: Center(child: Text(t.achievements.placeholder)),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const GamePage()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
      ),
    );
  }
}
