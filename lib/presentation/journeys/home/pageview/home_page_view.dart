import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

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
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      CloneListViewFetchState fetchState =
          context.watch<CloneListViewCubit>().state;
      return CloneListView(
        onRefresh: () {
          context.read<CloneListViewCubit>().fetchFirstPage(cloneType);
        },
        onLoadMore: () {
          context.read<CloneListViewCubit>().fetchNextPage(cloneType);
        },
        onItemTap: (clone) async {
          CloneEntity newClone = await Navigator.of(context)
              .pushNamed('/clonedetail', arguments: clone) as CloneEntity;

          context.read<CloneListViewCubit>().set(newClone);
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
