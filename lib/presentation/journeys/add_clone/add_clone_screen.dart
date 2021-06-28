import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';

import 'package:redrotapp/presentation/journeys/add_clone/add_clone_body/add_clone_body.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';

import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/create_clone/create_clone_cubit.dart';
import 'package:redrotapp/presentation/widgets/app_fab.dart';

import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import '../../themes/app_theme.dart';

class AddCloneScreen extends StatelessWidget {
  final String title;
  AddCloneScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getItInstance<CloneListViewCubit>()),
        BlocProvider(create: (_) => getItInstance<CreateCloneCubit>()),
      ],
      child: Scaffold(
        appBar: RedrotAppBar(
          title: title,
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final authenticationState =
                context.read<AuthenticationCubit>().state;
            if (authenticationState is AuthenticationGuestAnthenticated) {
              return SizedBox();
            }
            final createState = context.watch<CreateCloneCubit>().state;

            Widget _fabChild = Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSecondary,
              size: Sizes.dimen_24,
            );
            if (createState is CreateCloneInProgress) {
              _fabChild = Center(
                child: Container(
                  width: Sizes.dimen_24,
                  height: Sizes.dimen_24,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSecondary,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            return AppFab(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _fabChild,
              ),
              onPressed: () {
                context.read<CreateCloneCubit>().create(title);
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocListener<CreateCloneCubit, CreateCloneState>(
          listener: (context, state) {
            if (state is CreateCloneSuccess) {
              final clone = state.cloneEntity;
              Navigator.of(context)
                  .pushReplacementNamed('/clonedetail', arguments: clone);
            }
          },
          child: AddCloneBody(
            cloneName: title,
          ),
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
