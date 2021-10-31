import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/common/functions.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';

import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_state.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_clone/delete_clone_cubit.dart';

import 'package:redrotapp/presentation/widgets/clone_list_view/clone_list_view.dart';
import 'package:redrotapp/presentation/widgets/delete_overlay.dart';

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
      return BlocListener<DeleteCloneCubit, DeleteCloneState>(
        listener: (context, state) {
          if (state is DeleteCloneInProgress) {
            showDeleteInprogressSnackbar(context);
          }
          if (state is DeleteCloneSuccess) {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("/home");
            showDeleteSuccessSnackbar(context);
          }
        },
        child: CloneListView(
          onItemDelete: (clone) async {
            final authenticationState =
                context.read<AuthenticationCubit>().state;
            if (authenticationState is AuthenticationGuestAnthenticated) {
              return;
            }
            final bool? isConfrim = await Navigator.of(context)
                .push(DeleteOverlay(clone.cloneName)) as bool?;
            if (isConfrim == true) {
              context.read<DeleteCloneCubit>().delete(clone.cloneId);
            }
          },
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
        ),
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
