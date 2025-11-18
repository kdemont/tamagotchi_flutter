import '../bloc/home_bloc.dart';

/// Minimal ViewModel that acts as a thin MVVM layer above the Bloc.
class HomeViewModel {
  final HomeBloc bloc;

  HomeViewModel(this.bloc);

  void feed() => bloc.add(const Feed());
  void play() => bloc.add(const Play());
  void sleep() => bloc.add(const Sleep());
  void clean() => bloc.add(const Clean());
  void refresh() => bloc.add(const LoadTamagotchi());
}
