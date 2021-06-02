import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:redrotapp/presentation/widgets/time_ago_text.dart';

import '../upload_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CloneDetailContent extends StatelessWidget {
  const CloneDetailContent({
    Key? key,
    required this.clone,
    required this.uploadState,
  }) : super(key: key);

  final CloneEntity clone;
  final ImageUploaderState uploadState;

  ButtonState get _buttonState {
    if (uploadState is ImageUploaderEmpty) {
      return ButtonState.Disable;
    }
    if (uploadState is ImageUploaderUploading) {
      return ButtonState.Uploading;
    }
    if (uploadState is ImageUploaderSuccess) {
      return ButtonState.Success;
    }
    if (uploadState is ImageUploaderFailure) {
      return ButtonState.Error;
    }
    return ButtonState.Initial;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.all(Sizes.dimen_8),
        decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clone.cloneName,
                    style: theme.textTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TimeagoText(clone.createdAt),
                ],
              ),
            ),
            UploadButton(
              onPressed: () {
                if (_buttonState == ButtonState.Initial) {
                  context.read<ImageUploaderCubit>().upload();
                }
              },
              buttonState: _buttonState,
            ),
          ],
        ),
      ),
    );
  }
}
