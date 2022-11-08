import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_games/games/games.dart';
import 'package:very_good_games/l10n/l10n.dart';

class GamesFilterButton extends StatelessWidget {
  const GamesFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter = context.select((GamesBloc bloc) => bloc.state.filter);

    return PopupMenuButton<GameViewFilter>(
      initialValue: activeFilter,
      onSelected: (filter) {
        context.read<GamesBloc>().add(GamesFilterChanged(filter));
      },
      icon: const Icon(Icons.filter_list_rounded),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: GameViewFilter.all,
            child: Text(l10n.gamesFilterAll),
          ),
          PopupMenuItem(
            value: GameViewFilter.favoriteOnly,
            child: Text(l10n.gamesFilterFavoriteOnly),
          ),
        ];
      },
    );
  }
}
