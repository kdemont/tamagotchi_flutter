import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// removed unused imports

import 'package:lottie/lottie.dart';
import 'package:tamagotchi_flutter/utils/lottie_preloader.dart';
// visual state info accessed through model; explicit import removed

import '../../utils/constants.dart';
import '../../models/visual_state.dart';
import '../bloc/home_bloc.dart';
import '../view_model/home_view_model.dart';
import '../widgets/stat_bar.dart';
import '../widgets/poop_overlay.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../game/view/game_page.dart';
import '../../achievements/view/achievements_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 1; // 0: Play, 1: Chambre (home), 2: Succès

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Ensure bloc loads current tamagotchi state when page is first shown
    // (use read to avoid rebuilding here)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const LoadTamagotchi());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reload to apply elapsed time and restart sensors if needed
      context.read<HomeBloc>().add(const LoadTamagotchi());
      context.read<HomeBloc>().startLightSensor();
    } else if (state == AppLifecycleState.paused) {
      // Stop sensors while app is backgrounded
      context.read<HomeBloc>().stopAccelerometer();
      context.read<HomeBloc>().stopLightSensor();
    }
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const GamePage())).then((_) {
        setState(() => _selectedIndex = 1);
      });
    } else if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AchievementsPage())).then((_) {
        setState(() => _selectedIndex = 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel(context.read<HomeBloc>());

    return Scaffold(
      //appBar: AppBar(title: const Text('Tamagotchi')),
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
                  Expanded(
                    child: BlocBuilder<HomeBloc, HomeState>(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
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

                              // Centered Lottie animation takes available space
                              Expanded(
                                child: Stack(
                                  children: [
                                    // Tamagotchi animation (hidden in cleaning mode)
                                    if (!state.isCleaningMode)
                                      Center(
                                        child: _AnimationSequencePlayer(
                                          key: ValueKey(t.state),
                                          animations: t.state.animations,
                                          width: MediaQuery.of(context).size.width *
                                              0.6,
                                          onSequenceComplete: () => viewModel.nonRepeatingEventComplete(),
                                        ),
                                      ),
                                    // "Frotte !" text in cleaning mode
                                    if (state.isCleaningMode)
                                      const Center(
                                        child: Text(
                                          'Frotte !',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF9B7C47),
                                          ),
                                        ),
                                      ),
                                    // Poop overlay
                                    PoopOverlay(
                                      poopCount: t.poopCount,
                                      isCleaningMode: state.isCleaningMode,
                                      poopRubCounts: state.poopRubCounts,
                                    ),
                                    // Exit cleaning mode button
                                    if (state.isCleaningMode)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: ElevatedButton(
                                          onPressed: () => context
                                              .read<HomeBloc>()
                                              .add(const ExitCleaning()),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: const Text('Quitter'),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Action buttons at the bottom: round icon buttons for Feed and Sleep
                              // Désactivés si un événement plus prioritaire est en cours
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        VisualState.canInterrupt(
                                              t.state,
                                              VisualState.eating,
                                            )
                                            ? viewModel.feed
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(14),
                                      backgroundColor: Colors.orangeAccent,
                                      disabledBackgroundColor:
                                          Colors.grey.shade400,
                                      minimumSize: const Size(56, 56),
                                    ),
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      color:
                                          VisualState.canInterrupt(
                                                t.state,
                                                VisualState.eating,
                                              )
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        // Allow cleaning if there are poops OR if can interrupt
                                        (t.poopCount > 0 ||
                                                VisualState.canInterrupt(
                                                  t.state,
                                                  VisualState.cleaning,
                                                ))
                                            ? viewModel.clean
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(14),
                                      backgroundColor: Colors.deepPurpleAccent,
                                      disabledBackgroundColor:
                                          Colors.grey.shade400,
                                      minimumSize: const Size(56, 56),
                                    ),
                                    child: Icon(
                                      Icons.cleaning_services,
                                      color:
                                          (t.poopCount > 0 ||
                                                  VisualState.canInterrupt(
                                                    t.state,
                                                    VisualState.cleaning,
                                                  ))
                                              ? Colors.white
                                              : Colors.grey.shade600,
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

/// Widget that plays a sequence of Lottie animations.
/// Non-repeating animations play once then advance to the next.
/// The last repeating animation loops indefinitely.
class _AnimationSequencePlayer extends StatefulWidget {
  final List<VisualAnimation> animations;
  final double width;
  final VoidCallback? onSequenceComplete;

  const _AnimationSequencePlayer({
    Key? key,
    required this.animations,
    required this.width,
    this.onSequenceComplete,
  }) : super(key: key);

  @override
  State<_AnimationSequencePlayer> createState() =>
      _AnimationSequencePlayerState();
}

class _AnimationSequencePlayerState extends State<_AnimationSequencePlayer>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  bool _isInitialized = false;

  VisualAnimation get _current => widget.animations[_currentIndex];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(_onStatus);
    _setupAnimation();
  }

  void _setupAnimation() {
    final compo = LottiePreloader.getComposition(
      ANIMATION_ASSET_PATH + _current.assetFileName,
    );

    if (compo != null) {
      _controller.duration = compo.duration;
      _isInitialized = true;
      // Start animation after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // If current animation is non-repeating and there's a next one, advance
      if (!_current.repeat && _currentIndex < widget.animations.length - 1) {
        _currentIndex++;
        _controller.reset();
        _setupAnimation();
        setState(() {});
      } else if (_current.repeat) {
        // Loop the repeating animation
        _controller.reset();
        _controller.forward();
      } else {
        // Non-repeating animation finished and no more animations
        widget.onSequenceComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final compo = LottiePreloader.getComposition(
      ANIMATION_ASSET_PATH + _current.assetFileName,
    );

    if (compo == null) {
      return SizedBox(
        width: widget.width,
        height: widget.width,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Lottie(
      composition: compo,
      controller: _controller,
      width: widget.width,
      fit: BoxFit.contain,
    );
  }
}
