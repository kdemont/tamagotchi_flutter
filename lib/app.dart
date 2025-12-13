import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamagotchi_flutter/routing/app_router.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/tamagotchi_repository.dart';
import 'splash/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp(map, {super.key});

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
          home: SplashPage(nextPageBuilder: () => AppRouter(repository: repo)),
          //home: const HomePage(),
        ),
      ),
    );
  }
}
