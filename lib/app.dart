import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/tamagotchi_repository.dart';
import 'home/view/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = TamagotchiRepository();

    return RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (_) => HomeBloc(repository: repo)..add(LoadTamagotchi()),
        child: MaterialApp(
          title: 'Tamagotchi MVVM + BLoC',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomePage(),
        ),
      ),
    );
  }
}
