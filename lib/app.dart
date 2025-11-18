import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/tamagotchi_repository.dart';
import 'services/tamagotchi_service.dart';
import 'home/view/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final TamagotchiRepository repo;
  late final TamagotchiService tamagotchiService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    repo = TamagotchiRepository();
    tamagotchiService = TamagotchiService(repository: repo);

    // Start the time-based events service and apply missed events
    _initializeService();
  }

  Future<void> _initializeService() async {
    await tamagotchiService.start();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    tamagotchiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        title: 'Tamagotchi Loading...',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repo),
        RepositoryProvider.value(value: tamagotchiService),
      ],
      child: BlocProvider(
        create: (_) => HomeBloc(
          repository: repo,
          tamagotchiService: tamagotchiService,
        )..add(const LoadTamagotchi()),
        child: MaterialApp(
          title: 'Tamagotchi',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomePage(),
        ),
      ),
    );
  }
}
