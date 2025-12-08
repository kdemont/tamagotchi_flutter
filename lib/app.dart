import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/tamagotchi_repository.dart';
import 'home/view/home_page.dart';
import 'splash/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp(map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = TamagotchiRepository();

    return RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (_) => HomeBloc(repository: repo),
        child: MaterialApp(
          title: 'Tamagotchi MVVM + BLoC',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SplashPage(nextPageBuilder: () => const HomePage()),
          //home: const HomePage(),
        ),
      ),
    );
  }
}
