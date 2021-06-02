import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:redrotapp/common/enum.dart';

import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_state.dart';

import 'package:redrotapp/presentation/widgets/clone_list_view/clone_list_view.dart';

class HomePageView extends StatefulWidget {
  final int index;

  HomePageView(this.index);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      CloneListViewFetchState fetchState =
          context.watch<CloneListViewCubit>().state;
      return CloneListView(
        onRefresh: () {
          _timer?.cancel();
          context.read<CloneListViewCubit>().fetchFirstPage(cloneType);
        },
        onLoadMore: () {
          _timer?.cancel();
          context.read<CloneListViewCubit>().fetchNextPage(cloneType);
        },
        onItemTap: (clone) async {
          _timer?.cancel();
          await Navigator.of(context)
              .pushNamed('/clonedetail', arguments: clone);
          _timer = Timer(Duration(milliseconds: 1000), () {
            context.read<CloneListViewCubit>().fetchFirstPage(cloneType);
          });
        },
        fetchState: fetchState,
      );
    });
  }

  CloneType get cloneType {
    switch (widget.index) {
      case 0:
        return CloneType.VerifyNeeded;
      case 1:
        return CloneType.Completed;
      case 2:
        return CloneType.All;
      default:
        return CloneType.All;
    }
  }
}
