import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../view_model/home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = HomeViewModel(context.read<HomeBloc>());

    return Scaffold(
      appBar: AppBar(title: const Text('Tamagotchi')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    final t = state.tamagotchi;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${t.name}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _statRow('Hunger', t.hunger),
                        _statRow('Energy', t.energy),
                        _statRow('Happiness', t.happiness),
                        _statRow('Cleanliness', t.cleanliness),
                        const SizedBox(height: 12),
                        Text('Age: ${t.age}'),
                      ],
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),

              const Spacer(),

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
    );
  }

  Widget _statRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label)),
          Expanded(child: LinearProgressIndicator(value: value / 100.0)),
          const SizedBox(width: 8),
          Text('$value'),
        ],
      ),
    );
  }
}
