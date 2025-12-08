import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/bloc/home_bloc.dart';
import '../bloc/game_bloc.dart';
import 'widgets/game_rules_view.dart';
import 'widgets/game_playing_view.dart';
import 'widgets/game_won_view.dart';
import 'widgets/game_lost_view.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(
        homeBloc: context.read<HomeBloc>(),
      ),
      child: Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameRules) {
              return const GameRulesView();
            } else if (state is GamePlaying) {
              return GamePlayingView(state: state);
            } else if (state is GameWon) {
              return GameWonView(state: state);
            } else if (state is GameLost) {
              return GameLostView(state: state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
