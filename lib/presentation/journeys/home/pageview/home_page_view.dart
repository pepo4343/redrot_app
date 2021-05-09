import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/home/detail_card/detail_card.dart';
import 'package:redrotapp/presentation/logic/cubit/all/all_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/completed/completed_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/fetch_state.dart';
import 'package:redrotapp/presentation/logic/cubit/verify_needed/verify_needed_cubit.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';

class HomePageView extends StatefulWidget {
  final int index;

  HomePageView(this.index);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final options = LiveOptions(
    showItemInterval: Duration(milliseconds: 100),
    showItemDuration: Duration(milliseconds: 300),
    visibleFraction: 0.01,
  );

  var _controller = ScrollController();
  VoidCallback _scrollListener = () {};

  @override
  void initState() {
    _scrollListener = () {
      final position = _controller.position;
      if (position.atEdge && position.pixels != 0) {
        _fetchNextPage(widget.index);
      }
    };
    _controller.addListener(_scrollListener);
    _fetchFirstPage(widget.index);

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        FetchState fetchState = _getCurrentState(context, widget.index);

        if (fetchState is FetchInitial) {
          return Center(
            child: LoadingIndicator(),
          );
        }

        List<CloneEntity> clones = [];
        if (fetchState is FetchInProgress) {
          clones = fetchState.clones;
        }
        if (fetchState is FetchSuccess) {
          clones = fetchState.clones;
        }

        return LiveList.options(
          controller: _controller,
          itemBuilder: (context, index, animation) {
            return _buildAnimatedItem(
              context,
              index,
              animation,
              clones[index],
            );
          },
          itemCount: clones.length,
          options: options,
        );
      },
    );
  }

  void _fetchFirstPage(int index) {
    switch (index) {
      case 0:
        context.read<VerifyNeededCubit>().fetchFirstPage();
        break;
      case 1:
        context.read<CompletedCubit>().fetchFirstPage();
        break;
      case 2:
        context.read<AllCubit>().fetchFirstPage();
        break;
      default:
    }
  }

  void _fetchNextPage(int index) {
    switch (index) {
      case 0:
        context.read<VerifyNeededCubit>().fetchNextPage();
        break;
      case 1:
        context.read<CompletedCubit>().fetchNextPage();
        break;
      case 2:
        context.read<AllCubit>().fetchNextPage();
        break;
      default:
    }
  }

  FetchState _getCurrentState(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.watch<VerifyNeededCubit>().state;
      case 1:
        return context.watch<CompletedCubit>().state;
      case 2:
        return context.watch<AllCubit>().state;
      default:
        return context.watch<VerifyNeededCubit>().state;
    }
  }

  Widget _buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
    CloneEntity clone,
  ) =>
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        child: DetailCard(
          clone: clone,
          index: index,
        ),
      );
}
