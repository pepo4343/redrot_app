import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_state.dart';
import 'package:redrotapp/presentation/widgets/clone_card/clone_card.dart';
import 'package:redrotapp/presentation/widgets/error_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../loading_indicator.dart';

class CloneListView extends StatefulWidget {
  Function? onLoadMore;
  Function onRefresh;
  Function(CloneEntity) onItemTap;
  Function(CloneEntity) onItemDelete;
  CloneListViewFetchState fetchState;
  CloneListView({
    this.onLoadMore,
    required this.onRefresh,
    required this.onItemTap,
    required this.onItemDelete,
    required this.fetchState,
  });
  @override
  _CloneListViewState createState() => _CloneListViewState();
}

class _CloneListViewState extends State<CloneListView> {
  var _controller = ScrollController();
  VoidCallback _scrollListener = () {};

  @override
  void initState() {
    if (isLoadMoreNeeded) {
      _scrollListener = () {
        final position = _controller.position;
        if (position.outOfRange && position.pixels >= 0) {
          widget.onLoadMore!();
        }
      };
      _controller.addListener(_scrollListener);
    }

    widget.onRefresh();
    super.initState();
  }

  bool get isLoadMoreNeeded => widget.onLoadMore != null;

  @override
  void dispose() {
    if (isLoadMoreNeeded) {
      _controller.removeListener(_scrollListener);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget pageContent = Container();
    List<CloneEntity> clones;

    if (widget.fetchState is CloneListViewFetchInProgress) {
      pageContent = Center(
        child: LoadingIndicator(),
      );
    }
    if (widget.fetchState is CloneListViewFetchNextPageInProgress) {
      clones =
          (widget.fetchState as CloneListViewFetchNextPageInProgress).clones;
      pageContent = _buildListView(
          clones, widget.fetchState is CloneListViewFetchNextPageInProgress);
    }
    if (widget.fetchState is CloneListViewFetchSuccess) {
      clones = (widget.fetchState as CloneListViewFetchSuccess).clones;
      pageContent = _buildListView(
          clones, widget.fetchState is CloneListViewFetchNextPageInProgress);
    }

    if (widget.fetchState is CloneListViewFetchFailure) {
      return Center(
        child: ErrorContainer(
          onRefresh: () {
            widget.onRefresh();
          },
        ),
      );
    }
    if (widget.fetchState is CloneListViewFetchEmpty) {
      pageContent = Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ไม่พบข้อมูล",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: Sizes.dimen_8,
            ),
            RefreshButton(onPressed: () {
              widget.onRefresh();
            })
          ],
        ),
      );
    }
    if (widget.fetchState is CloneListViewFetchFailure) {
      pageContent = Text("ผิดผลาด");
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: pageContent,
      layoutBuilder: (currentChild, previousChildren) => currentChild!,
    );
  }

  Widget _buildListView(List<CloneEntity> clones, bool isLoading) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onRefresh: () async {
        widget.onRefresh();
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics(),
        ),
        controller: _controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: Sizes.dimen_16,
            );
          }
          if (index - 1 == clones.length) {
            return AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Padding(
                padding: const EdgeInsets.all(Sizes.dimen_18),
                child: const LoadingIndicator(
                  width: Sizes.dimen_48,
                  height: Sizes.dimen_48,
                ),
              ),
            );
          }
          return Hero(
            tag: clones[index - 1].cloneId,
            child: CloneCard(
              onDelete: widget.onItemDelete,
              onTap: widget.onItemTap,
              clone: clones[index - 1],
            ),
          );
        },
        itemCount: clones.length + 2,
      ),
    );
  }
}
