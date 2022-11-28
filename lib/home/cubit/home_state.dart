part of 'home_cubit.dart';

enum HomeTab { games, releaseCalendar }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.games,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
