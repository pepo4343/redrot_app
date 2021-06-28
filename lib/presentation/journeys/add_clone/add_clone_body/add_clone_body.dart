import 'package:flutter/material.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
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
        onItemTap: (clone) async {
          CloneEntity newClone = await Navigator.of(context)
                  .pushReplacementNamed('/clonedetail', arguments: clone)
              as CloneEntity;

          context.read<CloneListViewCubit>().set(newClone);
        },
        fetchState: fetchState,
      );
    });
  }
}
