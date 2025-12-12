import 'package:flutter/material.dart';
import 'package:tamagotchi_flutter/gen/strings.g.dart';

/// Reusable bottom navigation bar used across app pages.
///
/// Provide [currentIndex] and an [onTap] callback to handle navigation.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.sports_esports),
          label: t.nav.game,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: t.nav.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.emoji_events),
          label: t.nav.achievements,
        ),
      ],
      selectedItemColor: const Color(0xFF654B1F),
      unselectedItemColor: Colors.brown,
      backgroundColor: const Color(0xFF4A3114),
      type: BottomNavigationBarType.fixed,
    );
  }
}
