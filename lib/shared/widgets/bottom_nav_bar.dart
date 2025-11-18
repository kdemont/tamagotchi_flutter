import 'package:flutter/material.dart';

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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'JEU'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'CHAMBRE'),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'SUCCÈS',
        ),
      ],
      selectedItemColor: const Color(0xFF654B1F),
      unselectedItemColor: Colors.brown,
      backgroundColor: const Color(0xFF4A3114),
      type: BottomNavigationBarType.fixed,
    );
  }
}
