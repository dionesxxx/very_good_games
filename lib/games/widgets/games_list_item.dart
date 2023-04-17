import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:very_good_games/games/models/game_view.dart';
import 'package:very_good_games/games/widgets/widgets.dart';
import 'package:very_good_games/theme/theme.dart';

class GamesListItem extends StatelessWidget {
  const GamesListItem({
    required this.gameView,
    super.key,
    this.onToggleFavorited,
  });

  final GameView gameView;
  final ValueChanged<bool>? onToggleFavorited;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 220,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      gameView.game.backgroundImage,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: defaultPadding / 2,
                    top: defaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 28,
                  width: 40,
                  child: Center(
                    child: Text(
                      gameView.game.rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              height: 260,
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gameView.game.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    gameView.game.name,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    gameView.game.released,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FavoritedButton(
                    isFavorited: gameView.isFavorite,
                    onToggleFavorited: onToggleFavorited,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
