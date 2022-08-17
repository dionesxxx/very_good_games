import 'package:flutter/material.dart';
import 'package:game_api/game_api.dart';

class GamesListItem extends StatelessWidget {
  const GamesListItem({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${game.id}', style: textTheme.caption),
        title: Text(game.name),
        isThreeLine: true,
        subtitle: Text(game.released),
        dense: true,
      ),
    );
  }
}
