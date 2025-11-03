import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../bloc/home_bloc.dart';
import '../view_model/home_view_model.dart';
import '../widgets/stat_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel(context.read<HomeBloc>());

    return Scaffold(
      appBar: AppBar(title: const Text('Tamagotchi')),
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
                            Text(
                              'Name: ${t.name}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
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
                            Text(
                              'Age: ${t.age}',
                              style: const TextStyle(color: Colors.white),
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

                  // Action buttons at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: viewModel.feed,
                        child: const Text('Feed'),
                      ),
                      ElevatedButton(
                        onPressed: viewModel.play,
                        child: const Text('Play'),
                      ),
                      ElevatedButton(
                        onPressed: viewModel.sleep,
                        child: const Text('Sleep'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: viewModel.clean,
                    child: const Text('Clean'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: viewModel.refresh,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
