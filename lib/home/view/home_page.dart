import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../bloc/home_bloc.dart';
import '../view_model/home_view_model.dart';
import '../widgets/stat_bar.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../game/view/game_page.dart';
import '../../achievements/view/achievements_page.dart';
import '../../services/tamagotchi_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // 0: Play, 1: Chambre (home), 2: Succès

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const GamePage()));
    } else if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AchievementsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel(context.read<HomeBloc>());

    return Scaffold(
      // TODO: remove once in production
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        onPressed: () async {
          final service = context.read<TamagotchiService>();
          await service.reset();
          viewModel.refresh();
        },
        child: const Icon(Icons.refresh, size: 20),
      ),
      body: Stack(
        children: [
          // Background image that covers the whole screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content with stats, centered Lottie and actions
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stats at the top
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoaded) {
                        final t = state.tamagotchi;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stats in a 2-column grid (two per row)
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // childAspectRatio tuned so each item is wide enough for the bar
                              childAspectRatio: 3.2,
                              children: [
                                StatBar(
                                  label: 'FAIM',
                                  value: t.hunger,
                                  icon: Icons.restaurant_menu,
                                ),
                                StatBar(
                                  label: 'ÉNERGIE',
                                  value: t.energy,
                                  icon: Icons.bolt,
                                ),
                                StatBar(
                                  label: 'JOIE',
                                  value: t.happiness,
                                  icon: Icons.favorite,
                                ),
                                StatBar(
                                  label: 'HYGIÈNE',
                                  value: t.cleanliness,
                                  icon: Icons.cleaning_services,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  t.name,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: Color(0xFF9B7C47)),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Age: ${t.age}',
                                  style: const TextStyle(
                                    color: Color(0xFF654B1F),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

                  // Centered Lottie animation takes available space
                  Expanded(
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/lice_attack.json',
                        width: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.contain,
                        repeat: true,
                        // Optionally you can control autoplay: true by default
                      ),
                    ),
                  ),

                  // Action buttons at the bottom: round icon buttons for Feed and Sleep
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: viewModel.feed,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Colors.orangeAccent,
                          minimumSize: const Size(56, 56),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: viewModel.clean,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Colors.deepPurpleAccent,
                          minimumSize: const Size(56, 56),
                        ),
                        child: const Icon(
                          Icons.cleaning_services,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onNavTap(index);
        },
      ),
    );
  }
}
