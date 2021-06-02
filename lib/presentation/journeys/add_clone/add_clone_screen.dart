import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';

import 'package:redrotapp/presentation/journeys/add_clone/add_clone_body/add_clone_body.dart';

import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';

import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import '../../themes/app_theme.dart';

const double _fabDimension = 56.0;

class AddCloneScreen extends StatelessWidget {
  final String title;
  AddCloneScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getItInstance<CloneListViewCubit>(),
      child: Scaffold(
        appBar: RedrotAppBar(
          title: title,
        ),
        floatingActionButton: _FabButton(
          title: title,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: AddCloneBody(
          cloneName: title,
        ),
      ),
    );
  }
}

class _FabButton extends StatelessWidget {
  const _FabButton({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.dimen_100),
          ),
          boxShadow: theme.secondaryBoxShadows,
        ),
        child: null,
      );
    });
  }
}

class _FabAdd extends StatelessWidget {
  const _FabAdd({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.add,
      size: 32,
      color: Theme.of(context).colorScheme.onSecondary,
    );
  }
}

class _FabLoading extends StatelessWidget {
  const _FabLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
  }
}
