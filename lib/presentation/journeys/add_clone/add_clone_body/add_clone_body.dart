import 'package:flutter/material.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_state.dart';

import 'package:redrotapp/presentation/widgets/clone_list_view/clone_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCloneBody extends StatelessWidget {
  final String cloneName;
  AddCloneBody({required this.cloneName});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      CloneListViewFetchState fetchState =
          context.watch<CloneListViewCubit>().state;
      return CloneListView(
        onRefresh: () =>
            context.read<CloneListViewCubit>().fetchByName(cloneName),
        onItemTap: (clone) {
          Navigator.of(context)
              .pushNamed('addredrot', arguments: clone.cloneName);
        },
        fetchState: fetchState,
      );
    });
  }
}
