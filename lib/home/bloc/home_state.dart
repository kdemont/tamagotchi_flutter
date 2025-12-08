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
  final List<int> poopRubCounts; // Rub counts for each of the 3 poop positions

  const HomeLoaded({
    required this.tamagotchi,
    this.isCleaningMode = false,
    this.poopRubCounts = const [0, 0, 0],
  });

  @override
  List<Object?> get props => [tamagotchi, isCleaningMode, poopRubCounts];

  HomeLoaded copyWith({
    Tamagotchi? tamagotchi,
    bool? isCleaningMode,
    List<int>? poopRubCounts,
  }) {
    return HomeLoaded(
      tamagotchi: tamagotchi ?? this.tamagotchi,
      isCleaningMode: isCleaningMode ?? this.isCleaningMode,
      poopRubCounts: poopRubCounts ?? this.poopRubCounts,
    );
  }
}
