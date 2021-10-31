import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/clone_detail/fab_add_redrot.dart';
import 'package:redrotapp/presentation/journeys/clone_detail/redrot_card.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_clone/delete_clone_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_redrot/delete_redrot_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:redrotapp/presentation/router/app_router.dart';
import 'package:redrotapp/presentation/widgets/app_fab.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_state.dart';
import 'package:redrotapp/presentation/widgets/animated_card.dart';
import 'package:redrotapp/presentation/widgets/clone_card/clone_card.dart';
import 'package:redrotapp/presentation/widgets/delete_overlay.dart';
import 'package:redrotapp/presentation/widgets/error_container.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';

import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/presentation/widgets/responsive.dart';
import "package:images_picker/images_picker.dart";

class CloneDetailScreen extends StatefulWidget {
  final CloneEntity clone;

  CloneDetailScreen({required this.clone});

  @override
  _CloneDetailScreenState createState() => _CloneDetailScreenState();
}

class _CloneDetailScreenState extends State<CloneDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getItInstance<CloneDetailCubit>(),
        ),
        BlocProvider(
          create: (context) => getItInstance<DeleteCloneCubit>(),
        ),
        BlocProvider(
          create: (context) => getItInstance<DeleteRedrotCubit>(),
        )
      ],
      child: Scaffold(
        appBar: RedrotAppBar(
          title: widget.clone.cloneName,
        ),
        floatingActionButton: Builder(builder: (context) {
          final authenticationState = context.read<AuthenticationCubit>().state;
          if (authenticationState is AuthenticationGuestAnthenticated) {
            return SizedBox();
          }
          return MultipleItemsFloatingActionButton(
            items: [
              FloatingActionButtonItem(
                  label: "คลังรูปภาพ",
                  svg: "assets/svgs/image_gallery.svg",
                  onPressed: () async {
                    List<Media>? res = await ImagesPicker.pick(
                      count: 10,
                      pickType: PickType.image,
                    );

                    if (res != null) {
                      context
                          .read<ImageUploaderCubit>()
                          .init(widget.clone, res);
                      await Navigator.of(context).pushNamed('/imagesupload');
                      context
                          .read<CloneDetailCubit>()
                          .fetch(widget.clone.cloneId);
                    }
                  }),
              FloatingActionButtonItem(
                  label: "กล้องถ่ายรูป",
                  svg: "assets/svgs/camera.svg",
                  onPressed: () async {
                    final res = await ImagesPicker.openCamera(
                      pickType: PickType.image,
                    );
                    if (res != null) {
                      context
                          .read<ImageUploaderCubit>()
                          .init(widget.clone, res);
                      await Navigator.of(context).pushNamed('/imagesupload');
                      context
                          .read<CloneDetailCubit>()
                          .fetch(widget.clone.cloneId);
                    }
                  }),
            ],
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Responsive(
          desktop: Placeholder(),
          tablet: Placeholder(),
          mobile: Column(
            children: [
              Expanded(
                child: Builder(builder: (context) {
                  CloneEntity clone = widget.clone;
                  final state = context.watch<CloneDetailCubit>().state;

                  Widget content = Container();
                  if (state is CloneDetailFetchInitial) {
                    content = _RedrotListView(clone: clone);
                  }
                  if (state is CloneDetailFetchSuccess) {
                    clone = state.clone;
                    content = _RedrotListView(clone: clone);
                  }
                  if (state is CloneDetailFetchEmpty) {
                    clone = state.clone;
                    content = _RedrotListView(clone: clone);
                  }

                  if (state is CloneDetailFetchFailure) {
                    content = Center(
                      child: ErrorContainer(onRefresh: () {
                        context.read<CloneDetailCubit>().fetch(clone.cloneId);
                      }),
                    );
                  }
                  if (state is CloneDetailFetchInProgress) {
                    content = Center(
                      child: LoadingIndicator(),
                    );
                  }

                  return BlocListener<DeleteRedrotCubit, DeleteRedrotState>(
                    listener: (context, state) {
                      if (state is DeleteRedrotInProgress) {
                        showDeleteInprogressSnackbar(context);
                      }
                      if (state is DeleteRedrotSuccess) {
                        context.read<CloneDetailCubit>().fetch(clone.cloneId);
                        showDeleteSuccessSnackbar(context);
                      }
                    },
                    child: BlocListener<DeleteCloneCubit, DeleteCloneState>(
                      listener: (context, state) {
                        if (state is DeleteCloneInProgress) {
                          showDeleteInprogressSnackbar(context);
                        }
                        if (state is DeleteCloneSuccess) {
                          Navigator.of(context).popUntil((route) => true);
                          Navigator.of(context).pushNamed("/home");
                          showDeleteSuccessSnackbar(context);
                        }
                      },
                      child: WillPopScope(
                        onWillPop: () async {
                          Navigator.of(context).pop(clone);
                          return false;
                        },
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          layoutBuilder: (currentChild, previousChildren) =>
                              currentChild!,
                          child: content,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RedrotListView extends StatelessWidget {
  _RedrotListView({
    Key? key,
    required this.clone,
  }) : super(key: key);

  final CloneEntity clone;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onRefresh: () async {
        context.read<CloneDetailCubit>().fetch(clone.cloneId);
      },
      child: ListView.builder(
        padding: EdgeInsets.only(top: Sizes.dimen_8, bottom: Sizes.dimen_80),
        physics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics(),
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Hero(
              tag: clone.cloneId,
              child: CloneCard(
                onDelete: (clone) async {
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
                clone: clone,
                onTap: (_) {},
                animation: false,
              ),
            );
          }
          final redrotIndex = index - 1;
          return _buildAnimatedItem(
            context,
            redrotIndex,
            clone,
          );
        },
        itemCount: clone.redrot.length + 1,
      ),
    );
  }

  Widget _buildAnimatedItem(
    BuildContext context,
    int index,
    CloneEntity cloneEntity,
  ) =>
      RedrotCard(
        redrotEntity: cloneEntity.redrot[index],
        onPressed: () async {
          final argument = RedrotDetailScreenArguments(
              clone: cloneEntity, redrotId: cloneEntity.redrot[index].redrotId);
          CloneEntity clone = await Navigator.of(context)
              .pushNamed("/redrotdetail", arguments: argument) as CloneEntity;

          context.read<CloneDetailCubit>().set(clone);
        },
        onDelete: (redrot) async {
          final authenticationState = context.read<AuthenticationCubit>().state;
          if (authenticationState is AuthenticationGuestAnthenticated) {
            return;
          }
          final bool? isConfrim = await Navigator.of(context)
              .push(DeleteOverlay("ลบข้อมูลเหี่ยวเน่าแดง")) as bool?;
          if (isConfrim == true) {
            context.read<DeleteRedrotCubit>().delete(redrot.redrotId);
          }
        },
      );
}
