import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/buttons_confirm_container.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/buttons_edit_container.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_detail_card_body.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_detail_image_container.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_edit_card_body.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/confirm_redrot/confirm_redrot_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/edit_redrot/edit_redrot_cubit.dart';
import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:redrotapp/presentation/widgets/status_badge.dart';
import '../../themes/app_theme.dart';
import 'buttons_confirm_container.dart';
import 'cane.dart';

class RedrotDetailScreen extends StatefulWidget {
  final CloneEntity initialClone;
  final RedrotEntity initialRedrot;

  static _RedrotDetailScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<_RedrotDetailScreenState>();
  }

  RedrotDetailScreen({
    Key? key,
    required this.initialClone,
    required redrotId,
  })  : this.initialRedrot = initialClone.redrot
            .firstWhere((element) => element.redrotId == redrotId),
        super(key: key);

  @override
  _RedrotDetailScreenState createState() => _RedrotDetailScreenState();
}

class _RedrotDetailScreenState extends State<RedrotDetailScreen> {
  late ScrollController _controller = ScrollController();

  ScrollController get scrollChange => _controller;
  bool isEditing = false;

  late ConfirmRedrotCubit confirmRedrotCubit =
      getItInstance<ConfirmRedrotCubit>();
  late EditRedrotCubit editRedrotCubit = confirmRedrotCubit.editRedrotCubit;

  @override
  void dispose() {
    confirmRedrotCubit.close();
    editRedrotCubit.close();
    super.dispose();
  }

  Widget _buildButtonContainer(RedrotEntity redrot, BuildContext context) {
    final authenticationState = context.read<AuthenticationCubit>().state;
    if (authenticationState is AuthenticationGuestAnthenticated) {
      return SizedBox();
    }

    if (isEditing) {
      return ButtonsEditContainer(
        onCancel: () {
          setState(() {
            isEditing = false;
          });
          context.read<EditRedrotCubit>().reset();
        },
        redrot: redrot,
      );
    }
    return ButtonsConfirmContainer(
      onCancel: () {
        setState(() {
          isEditing = true;
        });
      },
      redrot: redrot,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => confirmRedrotCubit,
        ),
        BlocProvider(
          create: (context) => editRedrotCubit,
        )
      ],
      child: Scaffold(
        appBar: RedrotAppBar(
          title: widget.initialClone.cloneName,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            RedrotEntity redrot = widget.initialRedrot;
            CloneEntity clone = widget.initialClone;
            final state = context.watch<ConfirmRedrotCubit>().state;

            if (state is ConfirmRedrotFetchSuccess) {
              redrot = state.redrot;
              clone = state.clone;
            }
            return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop(clone);
                return false;
              },
              child: SingleChildScrollView(
                controller: _controller,
                physics: const BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics(),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Sizes.dimen_8,
                      ),
                      _RedrotDetailCard(
                        redrotEntity: redrot,
                        isEditing: isEditing,
                      ),
                      SizedBox(
                        height: Sizes.dimen_8,
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          var curve = Curves.easeOut;
                          var opacityTween = Tween<double>(begin: 0, end: 1)
                              .chain(CurveTween(curve: curve));

                          return FadeTransition(
                            opacity: opacityTween.animate(animation),
                            child: child,
                          );
                        },
                        layoutBuilder: (currentChild, previousChildren) =>
                            currentChild!,
                        child: _buildButtonContainer(redrot, context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RedrotDetailCard extends StatelessWidget {
  final bool isEditing;
  const _RedrotDetailCard(
      {Key? key, required this.redrotEntity, required this.isEditing})
      : super(key: key);
  final RedrotEntity redrotEntity;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(20),
          ),
          color: Theme.of(context).colorScheme.cardColor,
          boxShadow: Theme.of(context).primaryBoxShadows,
        ),
        height: isEditing ? 660 : 560,
        child: Builder(builder: (context) {
          return Wrap(
            clipBehavior: Clip.hardEdge,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              RedrotDetailImageContainer(redrotEntity: redrotEntity),
              SizedBox(
                width: double.infinity,
                height: Sizes.dimen_8,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: StatusBadge(redrotEntity: redrotEntity)),
              AnimatedSwitcher(
                layoutBuilder: (currentChild, previousChildren) =>
                    currentChild!,
                duration: Duration(milliseconds: 300),
                child: isEditing
                    ? RedrotEditCardBody(
                        initialColor: redrotEntity.raw?.color ?? 0,
                        initialNode: redrotEntity.raw?.nodalTransgression ?? 0,
                        initialSpread: redrotEntity.raw?.lesionWidth ?? 0,
                        redrotEntity: redrotEntity,
                      )
                    : RedrotDetailCardBody(redrotEntity: redrotEntity),
              ),
            ],
          );
        }),
      ),
    );
  }
}
