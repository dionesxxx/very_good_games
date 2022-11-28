import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_games/games/view/view.dart';
import 'package:very_good_games/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          GamesPage(),
          SizedBox(
            child: Text('Release Calendar'),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent.withOpacity(0.95),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.games,
              icon: const Icon(Icons.home_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.releaseCalendar,
              icon: const Icon(Icons.calendar_month_rounded),
            )
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color: groupValue != value ? null : Theme.of(context).colorScheme.primary,
      icon: icon,
    );
  }
}
