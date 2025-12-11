part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final Tamagotchi tamagotchi;
  final bool isCleaningMode;
  final int globalRubCount; // Global rub count for sequential poop removal

  const HomeLoaded({
    required this.tamagotchi,
    this.isCleaningMode = false,
    this.globalRubCount = 0,
  });

  @override
  List<Object?> get props => [tamagotchi, isCleaningMode, globalRubCount];

  HomeLoaded copyWith({
    Tamagotchi? tamagotchi,
    bool? isCleaningMode,
    int? globalRubCount,
  }) {
    return HomeLoaded(
      tamagotchi: tamagotchi ?? this.tamagotchi,
      isCleaningMode: isCleaningMode ?? this.isCleaningMode,
      globalRubCount: globalRubCount ?? this.globalRubCount,
    );
  }
}
