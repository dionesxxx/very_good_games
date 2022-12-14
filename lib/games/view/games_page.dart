import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_games/games/games.dart';
import 'package:very_good_games/l10n/l10n.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamesBloc(
        gameRepository: context.read<GameRepository>(),
        userRepository: context.read<UserRepository>(),
      )
        ..add(GamesFetched())
        ..add(const GamesFavoitedSubscriptionRequested()),
      child: const GamesView(),
    );
  }
}

class GamesView extends StatefulWidget {
  const GamesView({super.key});

  @override
  State<GamesView> createState() => _GamesViewState();
}

class _GamesViewState extends State<GamesView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.gamesAppBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          GamesFilterButton(),
        ],
      ),
      body: BlocBuilder<GamesBloc, GamesState>(
        builder: (context, state) {
          switch (state.status) {
            case GamesStatus.failure:
              return Center(child: Text(l10n.failedFetchGames));
            case GamesStatus.success:
              final filteredGames = state.filteredGames.toList();

              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= filteredGames.length
                      ? const BottomLoader()
                      : GamesListItem(
                          key: ValueKey(filteredGames[index].game),
                          gameView: filteredGames[index],
                          onToggleFavorited: (isFavorited) {
                            context.read<GamesBloc>().add(
                                  GamesFavoriteToggle(
                                    game: filteredGames[index],
                                    isFavorited: isFavorited,
                                  ),
                                );
                          },
                        );
                },
                itemCount:
                    state.hasReachedMax || state.filter != GameViewFilter.all
                        ? filteredGames.length
                        : filteredGames.length + 1,
                controller: _scrollController,
              );

            case GamesStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<GamesBloc>().add(GamesFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
